import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// NOTE: Ensure this import points to your EditProfileScreen
import '../../../../data/repositories/customer_service/customer_service.dart';
import '../../../../models/CustomerM/customer_model.dart';
import '../../../../view_model/CustomerVM/customer_bloc.dart';
import '../../../../view_model/CustomerVM/customer_event.dart';
import '../../../../view_model/CustomerVM/customer_state.dart';
import '../edit_profile.dart';
import '../widgets/profile_header_shimmer.dart';

class ProfileHeader extends StatelessWidget {
  final int? customerId;
  final int completionPercentage;

  const ProfileHeader({
    Key? key,
    required this.customerId,
    this.completionPercentage = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressValue = completionPercentage / 100.0;
    return BlocProvider<CustomerBloc>(
      create: (context) => CustomerBloc(CustomerService())
        ..add(FetchCustomerEvent(customerId!)),
      child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const ProfileHeaderShimmer();
            }
            CustomerData customer = CustomerData.empty();

            if (state is CustomerLoaded) {
              customer = state.customer;
            } else if (state is CustomerError) {
              debugPrint('Customer Bloc Error: ${state.message}');
            }
            final name = customer.customerName.isNotEmpty ? customer.customerName : 'Guest User';
            final phone = customer.phoneNumber.isNotEmpty ? customer.phoneNumber : 'N/A';
            const int completion = 50;

            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.blue.shade100, blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.blue.shade300, blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.5),
                      child: CachedNetworkImage(
                        // Use a dynamic/real avatar URL if available, otherwise use placeholder
                        imageUrl: "https://www.online-tech.in/CustomerImage/${customer.photo}",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.blue.shade200,
                          highlightColor: Colors.blue.shade50,
                          child: Container(color: Colors.blue.shade200),
                        ),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: GoogleFonts.poppins(fontSize: 24, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  // Info + Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF1976D2))),
                        const SizedBox(height: 4),
                        Text(phone,
                            style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade600)),
                        const SizedBox(height: 12),
                        Text('Profile Completion: $completionPercentage%',
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade700)),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.blue.shade50,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit Button
                  GestureDetector(
                    onTap: () async {
                      // Get a reference to the CustomerBloc before navigation
                      final customerBloc = context.read<CustomerBloc>();

                      // 1. Await the result of navigation. The page returns when user hits back or saves.
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => EditProfileScreen(
                            name: customer.customerName,
                            email: customer.emailId,
                            phone: customer.phoneNumber,
                          ),
                          transitionsBuilder: (_, a, __, c) => SlideTransition(
                              position: a.drive(Tween(begin: const Offset(1, 0), end: Offset.zero)),
                              child: c),
                        ),
                      );

                      if (customer.id != 0) {
                        customerBloc.add(FetchCustomerEvent(customer.id));
                      } else if (customerId != null) {
                        // Fallback to the initial customerId if the loaded one was empty
                        customerBloc.add(FetchCustomerEvent(customerId!));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 1.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text('Edit',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueAccent)),
                    ),
                  )
                ],
              ),
            );
          }
      )
    );
  }
}