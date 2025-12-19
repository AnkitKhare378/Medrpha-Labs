// file: lib/view_model/OrderVM/OrderHistory/order_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/order_service/order__history_service.dart';
import '../../../view_model/OrderVM/OrderHistory/order_history_bloc.dart';
import 'order_detail_screen/order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int? orderId;
  const OrderHistoryScreen({super.key, this.orderId});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  // 🎯 Method to fetch the userId asynchronously
  Future<void> _fetchUserId() async {
    try {
      final id = await SharedPreferencesUtil.getUserId();
      setState(() {
        _userId = id;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userId = null; // Mark as error/not found
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Step 1: Handle Loading State ---
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final validUserId = _userId ?? 0;
    if (validUserId == 0) {
      return const Scaffold(
        body: Center(child: Text('User ID not available. Cannot load orders.')),
      );
    }

    // --- Step 3: Build BlocProvider and Screen ---
    return BlocProvider(
      create: (context) => OrderHistoryBloc(OrderHistoryService())
      // Pass the fetched userId and optional orderId to the BLoC event
        ..add(FetchOrderHistoryEvent(
          userId: validUserId,
          orderId: widget.orderId,
        )),
      child: OrderHistoryView(
        isSpecificOrder: widget.orderId != null,
        displayOrderId: widget.orderId,
      ),
    );
  }
}

class OrderHistoryView extends StatelessWidget {
  final bool isSpecificOrder;
  final int? displayOrderId;

  const OrderHistoryView({
    super.key,
    required this.isSpecificOrder,
    this.displayOrderId
  });

  // Helper for star rating widgets
  Widget _buildRatingStars(int filledStars) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < filledStars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  String _getOrderStatusDisplay(int statusId) {
    switch (statusId) {
      case 1:
        return 'Ordered';
      case 2:
        return 'Shipped';
      case 3:
        return 'Cancelled';
      default:
        return 'Processing';
    }
  }

  String _formatOrderDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isSpecificOrder ? 'Order #${displayOrderId}' : 'My Orders', // Dynamic Title
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search and Filters Section: Show only for general history, hide for specific order
          if (!isSpecificOrder)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search your order here',
                          hintStyle: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade600),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filters Button
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          'Filters',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1, color: Colors.grey),

          Expanded(
            child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
              builder: (context, state) {
                if (state is OrderHistoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is OrderHistoryError) {
                  return Center(child: Text(state.message));
                } else if (state is OrderHistoryLoaded) {
                  if (state.orders.isEmpty) {
                    return Center(
                      child: Text(
                        isSpecificOrder ? 'Order #${displayOrderId} not found.' : 'You have no orders.',
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      final firstItemName = order.items.isNotEmpty ? order.items.first.itemName : 'No Items';
                      final totalItemsCount = order.items.fold(0, (sum, item) => sum + item.quantity);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(orderId: order.orderId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(firstItemName,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(fontSize: 10)
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Order Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_getOrderStatusDisplay(order.orderStatus)} on ${_formatOrderDate(order.orderDate)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ...order.items.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 2.0),
                                        child: Text(
                                          '${item.quantity} x ${item.itemName}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),

                                    // Display total items if more than one item line exists
                                    if (order.items.length > 1)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          'Total ${totalItemsCount} items',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                    // Rating Section (Kept from original code)
                                    const SizedBox(height: 6),
                                    _buildRatingStars(0),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rate this product now',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Arrow Icon
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Icon(Icons.chevron_right, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text("Start loading orders."));
              },
            ),
          ),
        ],
      ),
    );
  }
}