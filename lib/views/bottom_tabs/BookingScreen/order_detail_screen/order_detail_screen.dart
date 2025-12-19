import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/order_service/order__history_service.dart';
import '../../../../models/OrderM/order_history.dart';
import '../../../../view_model/OrderVM/OrderHistory/order_history_bloc.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 1. Fetch userId from SharedPreferences
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final id = await SharedPreferencesUtil.getUserId();
      setState(() {
        _userId = id;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userId = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #${widget.orderId}')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final validUserId = _userId ?? 0;
    if (validUserId == 0) {
      return Scaffold(
        appBar: AppBar(title: Text('Order #${widget.orderId}')),
        body: const Center(child: Text('User ID not available.')),
      );
    }

    return BlocProvider(
      create: (context) => OrderHistoryBloc(OrderHistoryService())
        ..add(FetchOrderHistoryEvent(
          userId: validUserId,
          orderId: widget.orderId, // 🎯 Pass the specific orderId
        )),
      child: OrderDetailView(orderId: widget.orderId),
    );
  }
}

// --- OrderDetailView: UI for a single order ---
class OrderDetailView extends StatelessWidget {
  final int orderId;

  const OrderDetailView({super.key, required this.orderId});

  String _getOrderStatusDisplay(int statusId) {
    return statusId == 1 ? 'Ordered' : statusId == 2 ? 'Shipped' : statusId == 3 ? 'Cancelled' : 'Processing';
  }

  String _formatOrderDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
        builder: (context, state) {
          if (state is OrderHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderHistoryError) {
            return Center(child: Text('Failed to load order: ${state.message}'));
          } else if (state is OrderHistoryLoaded) {
            // Since we passed a specific orderId, we expect exactly one order
            if (state.orders.isEmpty) {
              return Center(child: Text('Order #$orderId not found.'));
            }
            final order = state.orders.first;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Order Summary ---
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ${order.orderNumber}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildDetailRow('Status:', _getOrderStatusDisplay(order.orderStatus), color: Colors.green),
                          _buildDetailRow('Order Date:', _formatOrderDate(order.orderDate)),
                          _buildDetailRow('Total Amount:', _formatCurrency(order.finalAmount), color: Colors.blueAccent, isLarge: true),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Items List ---
                  Text('Items (${order.items.length})', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...order.items.map((item) => _buildItemRow(item, context)).toList(),

                  const SizedBox(height: 20),

                  // --- Pricing Details ---
                  Text('Pricing', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  // Note: subTotal, discountAmount, etc., are missing in OrderHistoryModel/JSON structure,
                  // but you can calculate or fetch them if available. Using finalAmount here:
                  _buildPriceRow('Subtotal (Approx)', _formatCurrency(order.finalAmount)),
                  _buildPriceRow('Discount', _formatCurrency(0.0), isDiscount: true), // Placeholder
                  const Divider(),
                  _buildPriceRow('Total Paid', _formatCurrency(order.finalAmount), isTotal: true),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color color = Colors.black87, bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.poppins(fontSize: isLarge ? 16 : 14, fontWeight: isLarge ? FontWeight.w700 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItemModel item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(item.itemName.substring(0, 1), style: GoogleFonts.poppins(fontSize: 12))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${item.quantity} x ${_formatCurrency(item.unitPrice)}', style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          Text(_formatCurrency(item.quantity * item.unitPrice), style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    final color = isTotal ? Colors.blueAccent : (isDiscount ? Colors.red : Colors.black87);
    final weight = isTotal ? FontWeight.w700 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: weight)),
          Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: weight, color: color)),
        ],
      ),
    );
  }
}