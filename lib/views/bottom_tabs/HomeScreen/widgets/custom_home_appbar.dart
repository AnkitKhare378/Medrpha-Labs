import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/view_model/CustomerVM/customer_state.dart';
import 'package:medrpha_labs/views/Dashboard/pages/location_picker_screen.dart';
import 'package:medrpha_labs/views/Dashboard/pages/notification_page.dart';
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

    if (result != null && result is String && mounted) {
      setState(() {
        _displayLocation = result;
      });
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

              // Right Side: Notification & Select Labs
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.bell, size: 16,),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                          const NotificationPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}