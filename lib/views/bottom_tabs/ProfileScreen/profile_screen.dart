import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/section/search_app_bar.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/section/membership_card.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/section/profile_menu.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/section/profile_header.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/widgets/login_card_widget.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/widgets/profile_header_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/customer_service/customer_service.dart';
import '../../../models/CustomerM/customer_model.dart';
import '../../../view_model/CustomerVM/customer_bloc.dart';
import '../../../view_model/CustomerVM/customer_event.dart';
import '../../../view_model/CustomerVM/customer_state.dart';

class BloodTestProfileView extends StatefulWidget {
  const BloodTestProfileView({super.key});

  @override
  State<BloodTestProfileView> createState() => _BloodTestProfileViewState();
}

class _BloodTestProfileViewState extends State<BloodTestProfileView> {
  int _searchTextIndex = 0;
  late Timer _timer;
  final List<String> _searchTexts = [
    'Medicines', 'Fitness products', 'Health supplements',
    'Medical devices', 'Baby care', 'Personal care'
  ];

  int? _customerId;

  @override
  void initState() {
    super.initState();
    _loadUserId();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() => _searchTextIndex = (_searchTextIndex + 1) % _searchTexts.length);
      }
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId != null && mounted) {
      setState(() {
        _customerId = userId;
      });
    } else if (mounted) {
      setState(() {
        _customerId = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerId = _customerId!;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          SearchAppBar(rotatingText: _searchTexts[_searchTextIndex]),
          Expanded(
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                CustomerData customer = CustomerData.empty();
                String statusMessage = 'Loading...';

                if (state is CustomerLoading) {
                  return const Center(child: ProfileHeaderShimmer());
                } else if (state is CustomerLoaded) {
                  customer = state.customer;
                  statusMessage = 'Profile loaded.';
                } else if (state is CustomerError) {
                  statusMessage = 'Error: ${state.message}';
                  customer = CustomerData.empty();
                }
                final name = customer.customerName;
                final phone = customer.phoneNumber != 'N/A' && customer.phoneNumber.isNotEmpty
                    ? customer.phoneNumber
                    : 'N/A';
                final email = customer.emailId;
                const int completion = 50;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if(_customerId != 0)
                      ...[
                        ProfileHeader(
                          customerId: customerId,
                          completionPercentage: completion,
                        ),
                        SizedBox(height: 10,),
                        const MembershipCard(),
                        const SizedBox(height: 16),
                        const ProfileMenu(isLoggedIn: true,),
                        const SizedBox(height: 20),
                        Text(
                          '0.0.1 (Dev) - $statusMessage',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ]
                      else ...[
                        LoginCard(),
                        const ProfileMenu(isLoggedIn: false,),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}