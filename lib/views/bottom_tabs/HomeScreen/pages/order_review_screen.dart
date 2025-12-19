import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/Dashboard/dashboard_screen.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/delivery_by_card.dart';
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
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_bloc.dart'; // ASSUMED PATH
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_event.dart'; // ASSUMED PATH
import 'package:medrpha_labs/view_model/OrderVM/CreateOrder/create_order_state.dart'; // ASSUMED PATH

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

  // ✅ Function to format any address into multiline style
  String formatAddress(Map<String, String> address) {
    // ... (formatAddress logic remains the same) ...
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
    print("@@@ ${widget.paymentMethodId}");
    // ... (Default address and displayAddress logic remains the same) ...
    final defaultAddress = {
      'title': 'Home',
      'flat': 'Flat No. 3A',
      'street': 'Green Meadows Complex, Thiruvanmiyur Beach Road',
      'locality': 'Chennai',
      'pincode': '600041',
    };

    final displayAddress = selectedAddress != null
        ? selectedAddress!['address']!
        : formatAddress(defaultAddress);

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
              // ... (Pickup Details, Address Display, Edit Icon, Add/Select Address buttons) ...

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
                    Row(
                      // ... (Address display row) ...
                    ),
                    const SizedBox(height: 12),
                    // 🔹 ADD NEW ADDRESS
                    AddMoreTestButton(
                      // ... (ADD NEW ADDRESS button logic) ...
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
                    // 🔹 SELECT ADDRESS
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

              // 🔹 PAYMENT DETAILS CARD
              const PaymentDetailsCard(),
              const SizedBox(height: 10),

              // 🔹 PROCEED BUTTON - NOW WRAPPED IN BlocConsumer
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      // 🎯 WRAP THE BUTTON HERE
                      child: BlocConsumer<CreateOrderBloc, CreateOrderState>(
                        listener: (context, state) {
                          if (state is CreateOrderSuccess) {
                            // 1. Success message
                            context.read<CartProvider>().clearCartAfterOrder();
                            Navigator.of(context).push(
                              SlidePageRoute(
                                page: DashboardScreen(),
                              ),
                            );
                            showAppSnackBar(
                              context,
                              state.response.message ?? "Order Placed! #${state.response.orderNumber}",
                              // isError: false, (assuming showAppSnackBar has this logic)
                            );
                          } else if (state is CreateOrderFailure) {
                            // 3. Failure message
                            showAppSnackBar(context, state.message);
                          }
                        },
                        builder: (context, state) {
                          final bool isLoading = state is CreateOrderLoading;

                          return GridButton(
                            text: isLoading ? "Processing..." : "PROCEED TO PAYMENT",
                            backgroundColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            borderColor: AppColors.primaryColor,
                            onPressed: isLoading ? null : () {
                              context.read<CreateOrderBloc>().add(
                                PlaceOrderEvent(
                                  userId: widget.userId,
                                  cartId: widget.cartId,
                                  paymentMethodId: widget.paymentMethodId,
                                  subTotal: widget.subTotal,
                                  discountAmount: widget.discountAmount,
                                  finalAmount: widget.finalAmount, userAddressId: widget.selectedAddressId,
                                ),
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