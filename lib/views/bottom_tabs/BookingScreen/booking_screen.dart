import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/order_service/order__history_service.dart';
import '../../../models/OrderM/order_history.dart';
import '../../../view_model/OrderVM/OrderHistory/order_history_bloc.dart';
import 'order_detail_screen/order_detail_screen.dart';
import 'order_filter_bottom_sheet.dart'; // Ensure OrderFilters class is inside here

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

  Future<void> _fetchUserId() async {
    // Note: Ensure SharedPreferencesUtil is imported
    final id = await SharedPreferencesUtil.getUserId();
    setState(() {
      _userId = id;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final validUserId = _userId ?? 0;
    if (validUserId == 0) {
      return const Scaffold(body: Center(child: Text('User ID not available.')));
    }

    return BlocProvider(
      create: (context) => OrderHistoryBloc(OrderHistoryService())
        ..add(FetchOrderHistoryEvent(userId: validUserId, orderId: widget.orderId)),
      child: OrderHistoryView(
        isSpecificOrder: widget.orderId != null,
        displayOrderId: widget.orderId,
        userId: validUserId, // Pass userId to the view
      ),
    );
  }
}

class OrderHistoryView extends StatefulWidget {
  final bool isSpecificOrder;
  final int? displayOrderId;
  final int userId;

  const OrderHistoryView({
    super.key,
    required this.isSpecificOrder,
    this.displayOrderId,
    required this.userId,
  });

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  // Define currentFilters inside the State class
  OrderFilters currentFilters = OrderFilters();

  Widget _buildRatingStars(int filledStars) {
    return Row(
      children: List.generate(5, (index) => Icon(
        index < filledStars ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      )),
    );
  }

  String _getOrderStatusDisplay(int statusId) {
    switch (statusId) {
      case 1: return 'Ordered';
      case 2: return 'Shipped';
      case 3: return 'Cancelled';
      default: return 'Processing';
    }
  }

  String _formatOrderDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSpecificOrder ? 'Order #${widget.displayOrderId}' : 'My Orders',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!widget.isSpecificOrder)
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      // 🎯 FIXED: Open Bottom Sheet and catch result
                      final result = await showModalBottomSheet<OrderFilters>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => OrderFilterSheet(initialFilters: currentFilters),
                      );

                      if (result != null) {
                        setState(() { currentFilters = result; });
                        // 🎯 FIXED: Dispatch Event with filters
                        context.read<OrderHistoryBloc>().add(FetchOrderHistoryEvent(
                          userId: widget.userId,
                          status: currentFilters.status,
                          timeRange: currentFilters.timeRange,
                        ));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: currentFilters.isEmpty ? Colors.grey.shade300 : Colors.blueAccent
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list,
                              color: currentFilters.isEmpty ? Colors.black54 : Colors.blueAccent),
                          const SizedBox(width: 4),
                          Text('Filters', style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: currentFilters.isEmpty ? Colors.black : Colors.blueAccent
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
              builder: (context, state) {
                if (state is OrderHistoryLoading) return const Center(child: CircularProgressIndicator());
                if (state is OrderHistoryError) return Center(child: Text(state.message));
                if (state is OrderHistoryLoaded) {
                  if (state.orders.isEmpty) return const Center(child: Text('No orders found.'));

                  return ListView.separated(
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      final firstItemName = order.items.isNotEmpty ? order.items.first.itemName : 'No Items';
                      return InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(orderId: order.orderId),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60, height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(child: Text(firstItemName, style: GoogleFonts.poppins(fontSize: 10), textAlign: TextAlign.center)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${_getOrderStatusDisplay(order.orderStatus)} on ${_formatOrderDate(order.orderDate)}',
                                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 4),
                                    Text('${order.items.length} items', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                                    _buildRatingStars(0),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text("Ready to load."));
              },
            ),
          ),
        ],
      ),
    );
  }
}