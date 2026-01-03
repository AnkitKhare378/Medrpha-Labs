import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/PaymentMethodM/payment_method_model.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../view_model/CustomerVM/customer_bloc.dart';
import '../../../../view_model/CustomerVM/customer_event.dart';
import '../../../../view_model/CustomerVM/customer_state.dart';
import '../../../../view_model/PaymentVM/payment_cubit.dart';
import '../../../../view_model/PaymentVM/payment_state.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../HomeScreen/pages/order_review_screen.dart';
import '../../../../view_model/WalletVM/wallet_bloc.dart';
import '../../../../view_model/WalletVM/wallet_state.dart';

class CartBottomBar extends StatefulWidget {
  final int userId;
  final int cartId;
  final double subTotal;
  final double discountAmount;
  final double totalAmount;
  final int selectedAddressId;
  final int selectedAddressTypeId;
  final VoidCallback? onChangeAddress;
  final String deliveryAddress;

  const CartBottomBar({
    super.key,
    required this.userId,
    required this.cartId, // Required
    required this.subTotal, // Required
    required this.discountAmount,
    required this.selectedAddressId,
    required this.selectedAddressTypeId,
    required this.totalAmount,
    this.onChangeAddress,
    required this.deliveryAddress,
  });

  @override
  State<CartBottomBar> createState() => _CartBottomBarState();
}

class _CartBottomBarState extends State<CartBottomBar> {
  int? _customerId;
  PaymentMethodModel? _selectedMethod;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndDispatchCustomerEvent();
  }

  Future<void> _loadUserIdAndDispatchCustomerEvent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      // Debug print to verify ID is coming from storage
      print("Fetched User ID from Prefs: $userId");

      if (mounted) {
        setState(() {
          _customerId = userId ?? 0;
        });

        // Only trigger the Bloc event if we have a valid ID
        if (_customerId != 0) {
          context.read<CustomerBloc>().add(FetchCustomerEvent(_customerId!));
        } else {
          print("User ID is 0 or null, skipping customer fetch.");
        }
      }
    } catch (e) {
      print("Error loading user preferences: $e");
    }
  }

  void _setDefaultPaymentMethod(List<PaymentMethodModel> methods) {
    if (_selectedMethod == null && methods.isNotEmpty) {
      setState(() {
        _selectedMethod = methods.firstWhere(
          (m) => m.isActive,
          orElse: () => methods.first,
        );
      });
    }
  }

  void _showPaymentSelection(
    BuildContext context,
    List<PaymentMethodModel> methods,
    WalletState walletState,
  ) {
    final double currentWalletBalance = (walletState is WalletLoaded)
        ? walletState.walletData.currentBalance
        : 0.0;

    final bool isWalletLoading = walletState is WalletLoading;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    final method = methods[index];

                    final bool isWalletMethod = method.paymenName == "Wallet";

                    bool isMethodUsable = method.isActive;
                    String? subtitleOverride;
                    Color? iconColor = method.isActive
                        ? AppColors.primaryColor
                        : Colors.grey;

                    if (isWalletMethod) {
                      if (isWalletLoading) {
                        isMethodUsable = false;
                        subtitleOverride = "Wallet balance loading...";
                        iconColor = Colors.grey;
                      } else if (currentWalletBalance < widget.totalAmount) {
                        isMethodUsable = false;
                        subtitleOverride =
                            "Insufficient Balance: ₹${currentWalletBalance.toStringAsFixed(2)}";
                        iconColor = Colors.red;
                      } else {
                        subtitleOverride =
                            "Balance: ₹${currentWalletBalance.toStringAsFixed(2)}";
                        iconColor = AppColors.primaryColor;
                      }
                    }

                    return ListTile(
                      title: Text(
                        method.paymenName,
                        style: GoogleFonts.poppins(),
                      ),
                      subtitle: Text(
                        subtitleOverride ?? method.discraption,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: isMethodUsable
                              ? Colors.black54
                              : Colors.redAccent,
                        ),
                      ),
                      leading: Icon(
                        isWalletMethod
                            ? Icons.wallet_giftcard
                            : (isMethodUsable
                                  ? Icons.payment
                                  : Icons.lock_outline),
                        color: iconColor,
                      ),
                      trailing:
                          isMethodUsable && _selectedMethod?.id == method.id
                          ? Icon(
                              Icons.check_circle,
                              color: AppColors.primaryColor,
                            )
                          : null,

                      onTap: isMethodUsable
                          ? () {
                              setState(() {
                                _selectedMethod = method;
                              });
                              Navigator.pop(context);
                            }
                          : () {
                              if (isWalletMethod &&
                                  !isWalletLoading &&
                                  currentWalletBalance < widget.totalAmount) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Insufficient wallet balance. Total: ₹${widget.totalAmount.toStringAsFixed(2)} | Current Balance: ₹${currentWalletBalance.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.orange,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${method.paymenName} is currently unavailable.',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.grey,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, customerState) {
        // 1. IMPROVED LOGIC: Block "null", empty strings, and "N/A"
        bool isNameMissing = true;

        if (customerState is CustomerLoaded) {
          final name = customerState.customer.customerName?.toString().trim();

          if (name != null &&
              name.toLowerCase() != "null" &&
              name.toLowerCase() != "n/a" && // Added check for "N/A"
              name.isNotEmpty) {
            isNameMissing = false;
          }
          print("Debug Customer Name: $name");
        }

        return BlocConsumer<WalletBloc, WalletState>(
          listener: (context, walletState) {},
          builder: (walletContext, walletState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (widget.selectedAddressTypeId == 31) ...[
                        const Icon(Icons.home_outlined, color: Colors.orange, size: 22),
                      ] else if (widget.selectedAddressTypeId == 32) ...[
                        const Icon(Icons.work_outline, color: Colors.orange, size: 22),
                      ] else if (widget.selectedAddressTypeId == 33 || widget.selectedAddressTypeId == 0) ...[
                        const Icon(Icons.location_on_outlined, color: Colors.orange, size: 22),
                      ],
                      const SizedBox(width: 8),
                      if (widget.userId != 0) ...[
                        Expanded(
                          child: Text(
                            "Delivering to \n${widget.deliveryAddress}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: widget.onChangeAddress,
                          child: Text(
                            "Change",
                            style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ] else ...[
                        TextButton(
                          onPressed: () {
                            context.read<DashboardBloc>().add(DashboardTabChanged(4));
                            showAppSnackBar(context, "You firstly need to Login Select Address");
                          },
                          child: Text(
                            "Select Address",
                            style: GoogleFonts.poppins(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      BlocConsumer<PaymentCubit, PaymentState>(
                        listener: (context, state) {
                          if (state is PaymentLoaded) {
                            _setDefaultPaymentMethod(state.methods);
                          }
                        },
                        builder: (context, state) {
                          String paymentText = 'Select Payment Method';
                          bool isLoaded = false;
                          List<PaymentMethodModel> methods = [];

                          if (state is PaymentLoaded) {
                            methods = state.methods;
                            isLoaded = true;
                            if (_selectedMethod != null) {
                              paymentText = _selectedMethod!.paymenName;
                            }
                          } else if (state is PaymentError) {
                            paymentText = 'Error loading payment';
                          } else if (state is PaymentLoading) {
                            return Row(
                              children: [
                                const SizedBox(
                                  height: 12, width: 12,
                                  child: CircularProgressIndicator(strokeWidth: 1.5),
                                ),
                                const SizedBox(width: 4),
                                Text('Loading methods...', style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54)),
                              ],
                            );
                          }
                          return InkWell(
                            onTap: isLoaded && _selectedMethod != null
                                ? () => _showPaymentSelection(context, methods, walletState)
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.currency_rupee, size: 10, color: Colors.black54),
                                  const SizedBox(width: 4),
                                  Text(
                                    paymentText,
                                    style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w500, color: Colors.black87),
                                  ),
                                  const Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.black54),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "₹${widget.totalAmount.toStringAsFixed(0)} TOTAL",
                              style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.black87),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 1. Check Login
                                  if (widget.userId == 0) {
                                    context.read<DashboardBloc>().add(DashboardTabChanged(4));
                                    showAppSnackBar(context, "You firstly need to Login to place order");
                                    return;
                                  }

                                  // 2. Check Profile Name (NOW BLOCKS "N/A")
                                  if (isNameMissing) {
                                    showAppSnackBar(context, "Please update your profile name before placing order");
                                    return;
                                  }

                                  // 3. Check Payment Method
                                  if (_selectedMethod == null) {
                                    showAppSnackBar(context, "Please select a payment method");
                                    return;
                                  }

                                  // 4. Final Success Action
                                  Navigator.of(context).push(
                                    SlidePageRoute(
                                      page: OrderReviewScreen(
                                        cartId: widget.cartId,
                                        userId: widget.userId,
                                        subTotal: widget.subTotal,
                                        discountAmount: widget.discountAmount,
                                        finalAmount: widget.totalAmount,
                                        paymentMethodId: _selectedMethod!.id!,
                                        deliveryAddress: widget.deliveryAddress,
                                        selectedAddressId: widget.selectedAddressId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  "Place Order",
                                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
