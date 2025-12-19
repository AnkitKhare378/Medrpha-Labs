import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:medrpha_labs/views/exceptions/no_data_found_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/AddressM/get_address_model.dart';
import '../../../../view_model/AddressVM/DeleteAddress/delete_address_bloc.dart';
import '../../../../view_model/AddressVM/DeleteAddress/delete_address_event.dart';
import '../../../../view_model/AddressVM/DeleteAddress/delete_address_state.dart';
import '../../../../view_model/AddressVM/GetUserAddress/get_address_view_model.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../widgets/shimmer_loading_list.dart';
import 'add_address_page.dart';
import 'widgets/add_more_test_button.dart';
import 'widgets/grid_button.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({Key? key}) : super(key: key);

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  List<UserAddress> _addresses = [];
  int selectedIndex = 0;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchAddresses();
  }

  Future<void> _loadUserIdAndFetchAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');

    if (id != null) {
      setState(() => _userId = id);
      if (mounted) {
        context.read<GetUserAddressBloc>().add(FetchUserAddresses(id.toString()));
      }
    } else {
      debugPrint("User ID not found in SharedPreferences.");
    }
  }

  String formatAddress(Map<String, String> a) {
    final flat = a['flat'] ?? '';
    final street = a['street'] ?? '';
    final locality = a['locality'] ?? '';
    final pincode = a['pincode'] ?? '';

    return '$flat, $street, $locality – $pincode';
  }

  IconData _getIconForId(String? addressTypeIdString) {
    if (addressTypeIdString == null) return Icons.place_outlined;

    final id = int.tryParse(addressTypeIdString);
    if (id == null) return Icons.place_outlined;

    switch (id) {
      case 31:
        return Icons.home_outlined;
      case 32:
        return Icons.work_outline;
      case 33:
        return Icons.location_on_outlined;
      default:
        return Icons.place_outlined;
    }
  }

  void _onEditAddressTapped(BuildContext context, String addressId) async {
    final updatedAddress = await Navigator.of(context).push(
      SlidePageRoute(
        page: AddAddressPage(editAddressId: addressId),
      ),
    );

    if (updatedAddress != null && updatedAddress is bool && updatedAddress && mounted && _userId != null) {
      context.read<GetUserAddressBloc>().add(FetchUserAddresses(_userId!.toString()));
    }
  }

  void _onDeleteAddressTapped(BuildContext context, String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Delete Address', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content:  Text('Are you sure you want to delete this address?', style: GoogleFonts.poppins(fontSize: 14),),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: GoogleFonts.poppins(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
                // Dispatch the delete event
                context.read<DeleteAddressBloc>().add(DeleteUserAddress(addressId));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteAddressBloc, DeleteAddressState>(
      listener: (context, state) {
        if (state is DeleteAddressSuccess) {
          showAppSnackBar(context, state.message);
          if (_userId != null) {
            context.read<GetUserAddressBloc>().add(FetchUserAddresses(_userId!.toString()));
          }
        } else if (state is DeleteAddressError) {
          showAppSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Select Pickup Location',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              AddMoreTestButton(
                onPressed: () async {
                  final newAddress = await Navigator.of(context).push(
                    SlidePageRoute(page: const AddAddressPage()),
                  );
      
                  if (newAddress != null && newAddress is bool && newAddress && mounted) {
                    if (_userId != null) {
                      context.read<GetUserAddressBloc>().add(FetchUserAddresses(_userId!.toString()));
                    }
                  }
                },
                title: "ADD NEW ADDRESS",
                backgroundColor: Colors.white,
                textColor: Colors.black87,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<GetUserAddressBloc, GetUserAddressState>(
                  builder: (context, state) {
                    if (state is GetUserAddressLoading) {
                      return const ShimmerLoadingList(itemCount: 3);
                    }
                    if (state is GetUserAddressError) {
                      return NoDataFoundScreen();
                    }
                    if (state is GetUserAddressEmpty) {
                      return const Center(child: Text('No addresses found. Please add one.'));
                    }
                    if (state is GetUserAddressLoaded) {
                      _addresses = state.addresses;
                      if (_addresses.isEmpty) {
                        return const Center(child: Text('No addresses found. Please add one.'));
                      }
      
                      return ListView.builder(
                        itemCount: _addresses.length,
                        itemBuilder: (context, i) {
                          final a = _addresses[i];
                          final displayMap = a.toDisplayMap();
                          final formatted = formatAddress(displayMap);
                          final addressTypeId = displayMap['addressTypeId'];
                          return RadioListTile<int>(
                            value: i,
                            groupValue: selectedIndex,
                            onChanged: (val) => setState(() => selectedIndex = val!),
                            secondary: PopupMenuButton<String>(
                              color: Colors.white,
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String result) {
                                switch (result) {
                                  case 'edit':
                                    if (a.id != null) {
                                      _onEditAddressTapped(context, a.id.toString());
                                    } else {
                                      debugPrint("Address ID is missing for edit.");
                                    }
                                    break;
                                  case 'delete':
                                    _onDeleteAddressTapped(context, a.id.toString());
                                    break;
                                  default:
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.edit_note_outlined, color: AppColors.primaryColor,), // Your existing edit icon
                                      const SizedBox(width: 8),
                                      Text('Edit',style: GoogleFonts.poppins(color: AppColors.primaryColor) ),
                                    ],
                                  ),
                                ),
                                // 2. DELETE Option
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.delete, color: Colors.redAccent), // A clear delete icon, often colored red
                                      const SizedBox(width: 8),
                                      Text('Delete', style: GoogleFonts.poppins(color: Colors.redAccent)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Icon(_getIconForId(addressTypeId), color: Colors.grey[700], size: 20,),
                                const SizedBox(width: 5,),
                                Text(a.addressTitle ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14,),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              formatted,
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: Text(_userId == null ? 'Please log in to see addresses.' : 'Tap "ADD NEW ADDRESS"'));
                  },
                ),
              ),
      
              SizedBox(
                width: double.infinity,
                child: GridButton(
                  text: "CONFIRM ADDRESS",
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  borderColor: Colors.white,
                  onPressed: _addresses.isEmpty ? null : () {
                    final selected = _addresses[selectedIndex];
                    final displayMap = selected.toDisplayMap();
                    final formatted = formatAddress(displayMap);
                    final addressId = selected.id;
                    final addressTypeId = selected.addressTypeId;
                    Navigator.pop(context, {
                      ...displayMap,
                      'address': formatted,
                      'addressId': addressId,
                      'addressTypeId' : addressTypeId,
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}