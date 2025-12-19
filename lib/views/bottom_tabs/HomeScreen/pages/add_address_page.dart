import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart'; // Import for Placemark
import '../../../../models/AddressM/user_address_insert_model.dart' hide UpdateUserAddress;
import '../../../../view_model/AddressVM/AddressType/address_type_view_model.dart';
import '../../../../view_model/AddressVM/GetUserAddressById/get_user_address_by_id_view_model.dart';
import '../../../AppWidgets/app_snackbar.dart';
import 'widgets/address_edit_shimmer.dart';
import 'widgets/grid_button.dart';
import 'widgets/address_type_button.dart';
import 'widgets/address_type_shimmer.dart';
import 'widgets/form_field_widget.dart';
import '../../../../view_model/AddressVM/UserAddressInsert/user_address_insert_bloc.dart';
import '../../../../view_model/AddressVM/UserAddressInsert/user_address_insert_event.dart';
import '../../../../view_model/AddressVM/UserAddressInsert/user_address_insert_state.dart';
import '../../../../view_model/AddressVM/UserAddressUpdate/user_address_update_view_model.dart';
import 'widgets/location_picker_box.dart';

int _getAddressTypeIdFromName(String name, AddressTypeLoaded state) {
  final type = state.types.firstWhere(
        (t) => t.name == name,
    orElse: () => throw Exception('Address type not found'),
  );
  return type.id;
}

class AddAddressPage extends StatefulWidget {
  final String? editAddressId;
  final Map<String, String>? existingAddress;

  const AddAddressPage({Key? key, this.existingAddress, this.editAddressId}) : super(key: key);

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController flatCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();

  String _selectedAddressType = '';
  int? _userId;
  String? _addressDbId;

  String _selectedLatitude = '';
  String _selectedLongitude = '';

  final GlobalKey<LocationPickerBoxState> _locationPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserId();

    if (widget.editAddressId != null) {
      _addressDbId = widget.editAddressId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<GetUserAddressByIdBloc>().add(FetchUserAddressById(widget.editAddressId!));
      });
    } else if (widget.existingAddress != null) {
      _populateForm(widget.existingAddress!);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLocationPickerDialog();
      });
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    flatCtrl.dispose();
    streetCtrl.dispose();
    localityCtrl.dispose();
    pincodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    setState(() {
      _userId = id;
    });
    if (id == null) {
      debugPrint('⚠️ User ID not found in local storage.');
    }
  }

  Future<void> _saveNewAddressId(int addressId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('new_address_id', addressId);
      debugPrint('✅ Saved new address ID: $addressId to local storage.');
    } catch (e) {
      debugPrint('❌ Failed to save address ID to SharedPreferences: $e');
    }
  }

  /// Populates form fields and sets the selected address type.
  void _populateForm(Map<String, String> addressData) {
    titleCtrl.text = addressData['title'] ?? '';
    flatCtrl.text = addressData['flat'] ?? '';
    streetCtrl.text = addressData['street'] ?? '';
    localityCtrl.text = addressData['locality'] ?? '';
    pincodeCtrl.text = addressData['pincode'] ?? '';
    setState(() {
      // 🎯 This is the line that sets the pre-selected button based on the 'type' string
      _selectedAddressType = addressData['type'] ?? '';
      if(addressData['id'] != null) {
        _addressDbId = addressData['id'];
      }
      // ✅ Populate coordinates from existing address data
      _selectedLatitude = addressData['latitude'] ?? '';
      _selectedLongitude = addressData['longitude'] ?? '';
    });
  }

  // 💡 NEW: Method to parse and populate fields from the full address string
  // Updated to accept coordinates directly from the map picker result.
  void _populateFieldsFromAddressString({
    required String fullAddress,
    required double latitude,
    required double longitude,
  }) async {
    // 1. Store the coordinates in the state
    setState(() {
      _selectedLatitude = latitude.toString();
      _selectedLongitude = longitude.toString();
    });

    // 2. Try to reverse geocode the coordinates to get Placemark details
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Use the Placemark data to populate the fields
        flatCtrl.text = place.name ?? ''; // Can be flat/house number
        streetCtrl.text = place.street ?? place.thoroughfare ?? ''; // Street or Landmark
        localityCtrl.text = place.subLocality ?? place.locality ?? place.administrativeArea ?? ''; // Locality / Area
        pincodeCtrl.text = place.postalCode ?? '';


        showAppSnackBar(context, "Address fields populated from map selection. Coordinates set.");
        return;
      }
    } catch (e) {
      debugPrint("Error reverse geocoding to populate fields: $e");
    }

    // 3. Fallback: If geocoding fails, just put the full address into one field
    flatCtrl.text = fullAddress;
    streetCtrl.text = '';
    localityCtrl.text = '';
    pincodeCtrl.text = '';
    showAppSnackBar(context, "Could not fully parse address. Full address placed in 'Flat' field.");
  }

  // 💡 UPDATED: Method to show the custom location picker dialog
  Future<void> _showLocationPickerDialog() async {
    // ✅ Change the return type to SelectedLocationInfo
    final result = await showDialog<SelectedLocationInfo>(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(10),
          title: Text('Select Your Delivery Location', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
          content: LocationPickerBox(key: _locationPickerKey),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check),
              label: const Text('Confirm Location'),
              onPressed: () {
                final address = _locationPickerKey.currentState?.currentAddress;
                final coordinates = _locationPickerKey.currentState?.currentCoordinates; // ✅ Get coordinates

                if (address != null && coordinates != null) {
                  // ✅ Return the custom object containing address and coordinates
                  Navigator.pop(context, SelectedLocationInfo(
                    fullAddress: address,
                    latitude: coordinates.latitude,
                    longitude: coordinates.longitude,
                  ));
                } else {
                  Navigator.pop(context, null);
                }
              },
            ),
          ],
        );
      },
    );

    // ✅ Handle the returned SelectedLocationInfo object
    if (result != null) {
      // User selected an address, populate the form and coordinates
      _populateFieldsFromAddressString(
        fullAddress: result.fullAddress,
        latitude: result.latitude,
        longitude: result.longitude,
      );
    }
  }


  void _submitAddress(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_userId == null) {
      showAppSnackBar(context, "User not logged in. Please log in again.");
      return;
    }

    // ✅ ADD CHECK: Ensure location is selected
    if (_selectedLatitude.isEmpty || _selectedLongitude.isEmpty) {
      showAppSnackBar(context, "Please select a location from the map.");
      return;
    }

    final addressTypeState = context.read<AddressTypeBloc>().state;
    if (addressTypeState is! AddressTypeLoaded || _selectedAddressType.isEmpty) {
      showAppSnackBar(context, "Please select an Address Type.");
      return;
    }

    try {
      final addressTypeId = _getAddressTypeIdFromName(_selectedAddressType, addressTypeState);
      final isUpdating = _addressDbId != null;

      if (isUpdating) {
        final updateRequest = UserAddressUpdateRequest(
          id: _addressDbId!,
          addressTypeID: addressTypeId,
          userId: _userId.toString(),
          addressTitle: titleCtrl.text,
          flatHousNumber: flatCtrl.text,
          street: streetCtrl.text,
          locality: localityCtrl.text,
          pincode: pincodeCtrl.text,
          latitude: _selectedLatitude,
          longitude: _selectedLongitude,
        );
        context.read<UserAddressUpdateBloc>().add(UpdateUserAddress(updateRequest));

      } else {
        final insertRequest = UserAddressInsertRequest(
          addressTypeID: addressTypeId,
          userId: _userId.toString(),
          addressTitle: titleCtrl.text,
          flatHousNumber: flatCtrl.text,
          street: streetCtrl.text,
          locality: localityCtrl.text,
          pincode: pincodeCtrl.text,
          isDefault: true,
          latitude: _selectedLatitude,
          longitude: _selectedLongitude,
        );
        context.read<UserAddressInsertBloc>().add(InsertUserAddress(insertRequest));
      }

    } catch (e) {
      showAppSnackBar(context, e.toString().contains('not found')
          ? "Error: Invalid Address Type selected."
          : "Error preparing data: ${e.toString()}");
    }
  }

  /// Builds the main form content, including address type selection.
  Widget _buildAddressForm({required bool isFetchingData, required AddressTypeState typeState, required bool isSavingOrUpdating}) {
    if (isFetchingData) {
      return const AddressEditShimmer();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💡 Location selection button
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: OutlinedButton.icon(
                onPressed: _showLocationPickerDialog,
                icon: const Icon(Icons.location_on_outlined),
                label: const Text('PICK LOCATION FROM MAP'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            FormFieldWidget(controller: titleCtrl, label: 'Title'),
            FormFieldWidget(controller: flatCtrl, label: 'Flat / House Number'),
            FormFieldWidget(controller: streetCtrl, label: 'Street / Landmark'),
            FormFieldWidget(controller: localityCtrl, label: 'Locality / Area'),
            FormFieldWidget(
              controller: pincodeCtrl,
              label: 'Pincode',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Text("Select Address Type",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 14)),
            const SizedBox(height: 6),
            if (typeState is AddressTypeLoading)
              const AddressTypeShimmer()
            else if (typeState is AddressTypeLoaded)
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: typeState.types.map((type) {
                  return AddressTypeButton(
                    icon: _getIconForType(type.name),
                    label: type.name,
                    // Checks if this button's type name matches the selected state variable
                    isSelected: _selectedAddressType == type.name,
                    onTap: () {
                      setState(() {
                        _selectedAddressType = type.name;
                      });
                    },
                  );
                }).toList(),
              )
            else if (typeState is AddressTypeError)
                Text(
                  "⚠️ Failed to load address types",
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
            const SizedBox(height: 20),
            GridButton(
              text: widget.editAddressId == null
                  ? isSavingOrUpdating ? "SAVING..." : "SAVE ADDRESS"
                  : isSavingOrUpdating ? "UPDATING..." : "UPDATE ADDRESS",
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              borderColor: Colors.blueAccent,
              onPressed: isSavingOrUpdating || _userId == null
                  ? null
                  : () => _submitAddress(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAddressInsertBloc, UserAddressInsertState>(
      listenWhen: (prev, current) => widget.editAddressId == null,
      listener: (context, insertState) async {
        if (insertState is UserAddressInsertSuccess) {
          showAppSnackBar(context, insertState.response.message);
          await _saveNewAddressId(insertState.response.data);
          Navigator.pop(context, true);
        } else if (insertState is UserAddressInsertFailure) {
          showAppSnackBar(context, insertState.error);
        }
      },
      child: BlocListener<UserAddressUpdateBloc, UserAddressUpdateState>(
        listenWhen: (prev, current) => widget.editAddressId != null,
        listener: (context, updateState) {
          if (updateState is UserAddressUpdateSuccess) {
            showAppSnackBar(context, updateState.response.message);
            Navigator.pop(context, true);
          } else if (updateState is UserAddressUpdateFailure) {
            showAppSnackBar(context, updateState.error);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              widget.editAddressId == null
                  ? 'Manual Address Entry'
                  : 'Edit Address',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          body: BlocConsumer<GetUserAddressByIdBloc, GetUserAddressByIdState>(
            listenWhen: (previous, current) => widget.editAddressId != null,
            listener: (context, fetchState) {
              if (fetchState is GetUserAddressByIdLoaded) {
                // Address data loaded, populate the form, which includes setting _selectedAddressType
                // Assuming fetchState.address.toEditMap() now contains 'latitude' and 'longitude'
                _populateForm(fetchState.address.toEditMap());
              } else if (fetchState is GetUserAddressByIdError) {
                showAppSnackBar(context, 'Failed to load address for edit: ${fetchState.message}');
              }
            },
            builder: (context, fetchState) {
              final isFetchingData = widget.editAddressId != null && fetchState is GetUserAddressByIdLoading;

              final isInsertLoading = context.watch<UserAddressInsertBloc>().state is UserAddressInsertLoading;
              final isUpdateLoading = context.watch<UserAddressUpdateBloc>().state is UserAddressUpdateLoading;
              final isSavingOrUpdating = isInsertLoading || isUpdateLoading;

              return BlocBuilder<AddressTypeBloc, AddressTypeState>(
                builder: (context, typeState) {
                  return _buildAddressForm(
                    isFetchingData: isFetchingData,
                    typeState: typeState,
                    isSavingOrUpdating: isSavingOrUpdating,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String name) {
    switch (name.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'office':
      case 'work':
        return Icons.work_outline;
      case 'other':
        return Icons.location_on_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}