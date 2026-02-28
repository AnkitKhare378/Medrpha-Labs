// File: lib/views/bottom_tabs/HomeScreen/pages/order_review_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:medrpha_labs/config/apiConstant/api_constant.dart';
import 'package:medrpha_labs/core/constants/app_colors.dart';
import 'package:medrpha_labs/view_model/provider/family_provider.dart';
import 'package:medrpha_labs/views/bottom_tabs/ProfileScreen/pages/family_members_page.dart';
import 'package:medrpha_labs/views/bottom_tabs/BookingScreen/order_detail_screen/order_detail_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/delivery_by_card.dart';
import '../../../../view_model/FamilyMemberVM/get_family_members_view_model.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/payment_details_card.dart';
import 'add_address_page.dart';
import 'select_address_page.dart';
import 'widgets/add_more_test_button.dart';
import 'widgets/grid_button.dart';
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
  final String slotTime;
  final String slotDate;

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
    required this.slotTime,
    required this.slotDate
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  String? currentDeliveryAddress;
  int? currentAddressId;

  @override
  void initState() {
    super.initState();
    currentDeliveryAddress = widget.deliveryAddress;
    currentAddressId = widget.selectedAddressId;

    // 🎯 Trigger fetch for family members to enable auto-selection
    context.read<GetFamilyMembersCubit>().fetchFamilyMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocListener<GetFamilyMembersCubit, GetFamilyMembersState>(
        // 🎯 Listen for loaded state to auto-select the first member
        listener: (context, state) {
          if (state is GetFamilyMembersLoaded) {
            context.read<FamilyProvider>().setInitialMember(state.members);
          }
        },
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
                      Text(
                        "Address Details",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "$currentDeliveryAddress",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),

                      // AddMoreTestButton(
                      //   title: "RESELECT ADDRESS",
                      //   backgroundColor: Colors.blueAccent,
                      //   borderColor: Colors.blueAccent,
                      //   textColor: Colors.white,
                      //   onPressed: () async {
                      //     final result = await Navigator.of(context).push(SlidePageRoute(page: const SelectAddressPage()));
                      //     if (result != null && result is Map<String, dynamic> && mounted) {
                      //       setState(() {
                      //         currentDeliveryAddress = result['address'];
                      //         currentAddressId = result['addressId'];
                      //       });
                      //     }
                      //   },
                      // ),
                      // const SizedBox(height: 20),
                      Text(
                        "Patient Profile",
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),

                      // 🔹 PATIENT PROFILE DISPLAY
                      Consumer<FamilyProvider>(
                        builder: (context, familyProvider, child) {
                          final member = familyProvider.selectedMember;
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                            ),
                            child: member == null
                                ? Row(
                              children: [
                                const Icon(Icons.person_outline, color: Colors.orange),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Loading profiles...",
                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).push(SlidePageRoute(page: const FamilyMembersPage())),
                                  child: Text("Select Manually", style: GoogleFonts.poppins(color: AppColors.primaryColor)),
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
                                      ? const Icon(Icons.person, color: AppColors.primaryColor)
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
                                  onPressed: () => Navigator.of(context).push(SlidePageRoute(page: const FamilyMembersPage())),
                                  child: Text("Change", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // const SizedBox(height: 20),
                      // AddMoreTestButton(
                      //   title: "ADD NEW ADDRESS",
                      //   backgroundColor: Colors.white,
                      //   textColor: Colors.black87,
                      //   onPressed: () async {
                      //     await Navigator.of(context).push(SlidePageRoute(page: const AddAddressPage()));
                      //   },
                      // ),
                      ////
                      const SizedBox(height: 16),
                      DeliveryByCard(orderTime: widget.slotTime, orderDate: widget.slotDate,),
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
                        child: Consumer<FamilyProvider>(
                          builder: (context, familyProvider, child) {
                            return BlocConsumer<CreateOrderBloc, CreateOrderState>(
                              listener: (context, state) {
                                if (state is CreateOrderSuccess) {
                                  context.read<CartProvider>().clearCartAfterOrder();
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //   SlidePageRoute(page: DashboardScreen()),
                                  //       (route) => false,
                                  // );
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrderDetailScreen(orderId: state.response.data ?? 0)));
                                  showAppSnackBar(context, state.response.message ?? "Order Placed Successfully!");
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

                                    // Use the LATEST currentAddressId (either original or updated)
                                    context.read<CreateOrderBloc>().add(
                                      PlaceOrderEvent(
                                        userId: widget.userId,
                                        cartId: widget.cartId,
                                        paymentMethodId: widget.paymentMethodId,
                                        subTotal: widget.subTotal,
                                        // discountAmount: widget.discountAmount,
                                        discountAmount: 0,
                                        finalAmount: widget.finalAmount,
                                        userAddressId: currentAddressId ?? widget.selectedAddressId, orderTime: widget.slotTime, orderDate: widget.slotDate,
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
      ),
    );
  }
}