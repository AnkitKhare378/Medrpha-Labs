import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/view_model/CustomerVM/customer_state.dart';
import 'package:medrpha_labs/view_model/provider/family_provider.dart';
import 'package:medrpha_labs/views/Dashboard/pages/location_picker_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/app_bar_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../view_model/CustomerVM/customer_bloc.dart';
import '../../../../view_model/CustomerVM/customer_event.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';

bool _hasAutoOpenedLocation = false;

class CustomHomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String location;

  const CustomHomeAppBar({
    super.key,
    required this.location,
  });

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  int? _customerId;
  String _displayLocation = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _displayLocation = widget.location;
    _loadUserIdAndDispatchCustomerEvent();
    _initLocationLogic();
  }

  // Future<void> _initLocationLogic() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedAddr = prefs.getString('user_selected_address');
  //
  //   if (mounted) {
  //     if (savedAddr != null && savedAddr.isNotEmpty) {
  //       setState(() {
  //         _displayLocation = savedAddr;
  //       });
  //       _hasAutoOpenedLocation = true;
  //     } else if (!_hasAutoOpenedLocation && (_displayLocation == 'Fetching...' || _displayLocation.isEmpty)) {
  //       _hasAutoOpenedLocation = true;
  //       WidgetsBinding.instance.addPostFrameCallback((_) => _handleLocationSelection());
  //     }
  //   }
  // }

  Future<void> _initLocationLogic() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAddr = prefs.getString('user_selected_address');

    if (mounted) {
      if (savedAddr != null && savedAddr.isNotEmpty) {
        setState(() => _displayLocation = savedAddr);
      } else {
        // No saved address: Open picker in auto-fetch mode
        _handleLocationSelection(isAutoFetch: true);
      }
    }
  }

  Future<void> _loadUserIdAndDispatchCustomerEvent() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (mounted) {
      setState(() {
        _customerId = userId ?? 0;
      });
      context.read<CustomerBloc>().add(FetchCustomerEvent(_customerId!));
    }
  }

  String _getShortLocation(String fullAddress) {
    if (fullAddress == 'Fetching...' || fullAddress.trim().isEmpty) {
      return 'Select Location';
    }
    if (fullAddress.contains(',')) {
      final parts = fullAddress.split(',');
      if (parts.length >= 2) {
        final specificPart = parts[0].trim();
        final areaPart = parts[1].trim();
        String combined = '$specificPart, $areaPart';
        return combined.length > 30 ? '${combined.substring(0, 27)}...' : combined;
      }
      return parts.first.trim();
    }
    return fullAddress.length > 25 ? '${fullAddress.substring(0, 25)}...' : fullAddress;
  }

  void _handleLocationSelection({bool isAutoFetch = false}) async {
    final result = await Navigator.of(context).push(
      SlidePageRoute(
          page: LocationPickerScreen(isAutoFetch: isAutoFetch) // Pass a flag
      ),
    );

    if (result != null && result is Map<String, dynamic> && mounted) {
      final newAddress = result['address'] ?? "Unknown Location";
      setState(() {
        _displayLocation = newAddress;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_selected_address', newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final selectedFamilyMember = familyProvider.selectedMember;

    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        String displayName = 'User';
        String? profileUrl; // ✅ Variable to capture the URL from Bloc

        if (selectedFamilyMember != null) {
          displayName = selectedFamilyMember.firstName;
        } else if (state is CustomerLoaded) {
          displayName = state.customer.customerName;
          profileUrl = state.customer.photo; // ✅ Extract photo from state
        } else if (state is CustomerLoading) {
          displayName = 'Loading...';
        }

        String getFirstName(String fullName) {
          if (fullName.trim().isEmpty || fullName == 'Loading...') return 'User';
          return fullName.split(' ').first;
        }

        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName == "N/A" ? 'Welcome, Guest' : 'Welcome, ${getFirstName(displayName)}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleLocationSelection,
                    child: Row(
                      children: [
                        Text('Location: ', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[700])),
                        Text(
                          _getShortLocation(_displayLocation),
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.blueAccent),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // ✅ Pass the profileUrl from CustomerBloc state
              AppBarIcons(profileUrl: profileUrl),
            ],
          ),
        );
      },
    );
  }
}

