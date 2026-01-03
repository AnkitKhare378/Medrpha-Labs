import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/view_model/CustomerVM/customer_state.dart';
import 'package:medrpha_labs/views/Dashboard/pages/location_picker_screen.dart';
import 'package:medrpha_labs/views/Dashboard/pages/notification_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/widgets/app_bar_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/CustomerM/customer_model.dart';
import '../../../../view_model/CustomerVM/customer_bloc.dart';
import '../../../../view_model/CustomerVM/customer_event.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';

class CustomHomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String location;

  const CustomHomeAppBar({
    super.key,
    required this.location,
  });

  @override
  State<CustomHomeAppBar> createState() => _CustomHomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomHomeAppBarState extends State<CustomHomeAppBar> {
  int? _customerId;
  // 1. Initialize location with the widget's provided value
  String _displayLocation = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _loadUserIdAndDispatchCustomerEvent();
    _displayLocation = widget.location;
  }

  Future<void> _loadUserIdAndDispatchCustomerEvent() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    print(userId);
    if (mounted) {
      setState(() {
        _customerId = userId ?? 0;
      });
      context.read<CustomerBloc>().add(FetchCustomerEvent(_customerId!));
    }
  }

  String _getShortLocation(String fullAddress) {
    if (fullAddress.contains(',')) {
      final parts = fullAddress.split(',');
      if (parts.length >= 2) {
        final specificPart = parts.first.trim();
        final cityPart = parts[1].trim();
        return '$specificPart, $cityPart';
      }
      return parts.first.trim();
    }
    if (fullAddress.length > 25) {
      return fullAddress.substring(0, 25) + '...';
    }
    return fullAddress;
  }

  void _handleLocationSelection() async {
    final result = await Navigator.of(context).push(
      SlidePageRoute(
        page: const LocationPickerScreen(),
      ),
    );

    // Check if result is a Map (since you are returning multiple values now)
    if (result != null && result is Map<String, dynamic> && mounted) {
      setState(() {
        // Update the display string using the 'address' key from the map
        _displayLocation = result['address'] ?? "Unknown Location";

        // Optional: Store coordinates locally in this class if needed
        // _selectedLat = result['lat'];
        // _selectedLng = result['lng'];
      });

      print("Location Updated to: $_displayLocation");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state){
        String userName = 'User';
        if (state is CustomerLoaded) {
          userName = state.customer.customerName;
        } else if (state is CustomerLoading) {
          userName = 'Loading...';
        } else if (state is CustomerError) {
          print('Customer fetch error: ${state.message}');
        }
        String getFirstName(String fullName) {
          if (fullName.trim().isEmpty) {
            return 'User';
          }
          return fullName.split(' ').first;
        }
        String firstName = getFirstName(userName);
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
                    'Welcome, $firstName',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    // **FIX 2:** Call the handling method to await the result
                    onTap: _handleLocationSelection,
                    child: Row(
                      children: [
                        Text(
                          'Location: ',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          _getShortLocation(_displayLocation),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              AppBarIcons(),

            ],
          ),
        );
      },
    );
  }
}