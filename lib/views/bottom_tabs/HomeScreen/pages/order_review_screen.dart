import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Added Provider
import 'package:medrpha_labs/config/apiConstant/api_constant.dart'; // Added ApiConstants
import 'package:medrpha_labs/views/Dashboard/dashboard_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/delivery_by_card.dart';
import 'package:medrpha_labs/view_model/provider/family_provider.dart'; // Added FamilyProvider
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/family_members_page.dart'; // Added FamilyMembersPage

import '../../../../core/constants/app_colors.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/payment_details_card.dart';
import 'add_address_page.dart';
import 'select_address_page.dart';
import 'widgets/add_more_test_button.dart';
import 'widgets/grid_button.dart';

// Import Order BLoC components
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_bloc.dart';
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_event.dart';
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_state.dart';

class OrderReviewScreen extends StatefulWidget {
  final int userId;
  final int cartId;
  final int selectedAddressId;
  final int paymentMethodId;
  final String deliveryAddress;
  final double subTotal;
  final double discountAmount;
  final double finalAmount;

  const OrderReviewScreen({
    super.key,
    required this.userId,
    required this.cartId,
    required this.selectedAddressId,
    required this.paymentMethodId,
    required this.deliveryAddress,
    required this.subTotal,
    required this.finalAmount,
    required this.discountAmount,
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  Map<String, String>? selectedAddress;

  String formatAddress(Map<String, String> address) {
    final flat = address['flat'] ?? '';
    final street = address['street'] ?? '';
    final locality = address['locality'] ?? '';
    final pincode = address['pincode'] ?? '';
    final parts = street.split(',');
    String formattedStreet = '';
    for (int i = 0; i < parts.length; i++) {
      formattedStreet += parts[i].trim();
      if (i < parts.length - 1) {
        formattedStreet += ',\n';
      }
    }
    return '$flat\n$formattedStreet\n$locality – $pincode';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Order Review", style: GoogleFonts.poppins()),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 PICKUP DETAILS
                    Text(
                      "Pickup Details",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Delivering to \n${widget.deliveryAddress}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 SELECTED PATIENT PROFILE SECTION
                    Text(
                      "Patient Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<FamilyProvider>(
                      builder: (context, familyProvider, child) {
                        final member = familyProvider.selectedMember;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.2),
                            ),
                          ),
                          child: member == null
                              ? Row(
                            children: [
                              const Icon(Icons.person_add_alt_1, color: Colors.orange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "No profile selected for this order",
                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  SlidePageRoute(page: const FamilyMembersPage()),
                                ),
                                child: const Text("Select Profile"),
                              )
                            ],
                          )
                              : Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                backgroundImage: member.uploadPhoto != null && member.uploadPhoto!.isNotEmpty
                                    ? NetworkImage('${ApiConstants.familyMembersImageUrl}${member.uploadPhoto}')
                                    : null,
                                child: (member.uploadPhoto == null || member.uploadPhoto!.isEmpty)
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${member.firstName} ${member.lastName}",
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
                                    ),
                                    Text(
                                      "Patient",
                                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  SlidePageRoute(page: const FamilyMembersPage()),
                                ),
                                child: Text(
                                  "Change",
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    // 🔹 ADDRESS ACTIONS
                    AddMoreTestButton(
                      title: "ADD NEW ADDRESS",
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          SlidePageRoute(page: const AddAddressPage()),
                        );
                        if (result != null && mounted) {
                          final formatted = formatAddress(result);
                          setState(() {
                            selectedAddress = {
                              'title': result['title'] ?? 'New Address',
                              'address': formatted,
                            };
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    AddMoreTestButton(
                      title: "SELECT ADDRESS",
                      backgroundColor: Colors.blueAccent,
                      borderColor: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          SlidePageRoute(page: const SelectAddressPage()),
                        );
                        if (result != null && mounted) {
                          final formatted = formatAddress(result);
                          setState(() => selectedAddress = {
                            ...Map<String, String>.from(result),
                            'address': formatted,
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // 🔹 DELIVERY CARD
                    const DeliveryByCard(dateTime: "01:30 PM, Tomorrow"),
                  ],
                ),
              ),

              const PaymentDetailsCard(),
              const SizedBox(height: 10),

              // 🔹 PROCEED BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<FamilyProvider>( // Added Consumer here to check selection state
                        builder: (context, familyProvider, child) {
                          return BlocConsumer<CreateOrderBloc, CreateOrderState>(
                            listener: (context, state) {
                              if (state is CreateOrderSuccess) {
                                context.read<CartProvider>().clearCartAfterOrder();
                                Navigator.of(context).pushAndRemoveUntil(
                                  SlidePageRoute(page: DashboardScreen()),
                                      (route) => false,
                                );
                                showAppSnackBar(
                                  context,
                                  state.response.message ?? "Order Placed Successfully!",
                                );
                              } else if (state is CreateOrderFailure) {
                                showAppSnackBar(context, state.message);
                              }
                            },
                            builder: (context, state) {
                              final bool isLoading = state is CreateOrderLoading;
                              final bool hasSelectedProfile = familyProvider.selectedMember != null;

                              return GridButton(
                                text: isLoading ? "Processing..." : "PROCEED TO PAYMENT",
                                backgroundColor: hasSelectedProfile ? AppColors.primaryColor : Colors.grey,
                                textColor: Colors.white,
                                borderColor: hasSelectedProfile ? AppColors.primaryColor : Colors.grey,
                                onPressed: (isLoading)
                                    ? null
                                    : () {
                                  if (!hasSelectedProfile) {
                                    showAppSnackBar(context, "Please select a patient profile first");
                                    return;
                                  }
                                  context.read<CreateOrderBloc>().add(
                                    PlaceOrderEvent(
                                      userId: widget.userId,
                                      cartId: widget.cartId,
                                      paymentMethodId: widget.paymentMethodId,
                                      subTotal: widget.subTotal,
                                      discountAmount: widget.discountAmount,
                                      finalAmount: widget.finalAmount,
                                      userAddressId: widget.selectedAddressId,
                                      // Note: Ensure your PlaceOrderEvent supports familyMemberId if required by API
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}