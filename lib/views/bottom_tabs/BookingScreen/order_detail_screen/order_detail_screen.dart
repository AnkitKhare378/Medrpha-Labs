import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medrpha_labs/views/bottom_tabs/BookingScreen/order_detail_screen/widgets/order_report_dialog.dart';
import '../../../../config/color/colors.dart';
import '../../../../data/repositories/order_service/order__history_service.dart';
import '../../../../models/OrderM/order_history.dart';
import '../../../../view_model/OrderVM/OrderHistory/order_history_bloc.dart';
import '../../../../view_model/OrderVM/OrderHistory/order_status_view_model.dart';

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

    // Providing multiple blocs if needed at the top level
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderHistoryBloc(OrderHistoryService())
            ..add(FetchOrderHistoryEvent(
              userId: _userId ?? 0,
              orderId: widget.orderId,
            )),
        ),
        // Adding OrderStatusBloc here so OrderDetailView can use it
        // BlocProvider(create: (context) => OrderStatusBloc(OrderStatusService())),
      ],
      child: OrderDetailView(orderId: widget.orderId),
    );
  }
}

class OrderDetailView extends StatelessWidget {
  final int orderId;

  OrderDetailView({super.key, required this.orderId});

  // --- Formatting Helpers ---
  String _formatOrderDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);
  String _formatCurrency(double amount) => NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(amount);

  final List<String> timeSlots = [
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM",
    "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM",
    "02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM",
    "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM",
  ];

  Future<void> _selectDateTime(BuildContext context) async {
    // 1. Pick Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null || !context.mounted) return;

    // 2. Pick Time Slot (Grid Dialog)
    final String? selectedSlot = await _showTimeSlotDialog(context);

    if (selectedSlot == null || !context.mounted) return;

    // 3. Combine and Send to Bloc
    final String formattedDate = "${pickedDate.toIso8601String().split('T')[0]} $selectedSlot";

    context.read<OrderStatusBloc>().add(
      UpdateOrderStatusRequested(
        orderId: orderId,
        statusType: 5,
        // scheduledAt: formattedDate, // Uncomment if your BLoC event supports this
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order rescheduled for $formattedDate')),
    );
  }

  Future<String?> _showTimeSlotDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time Slot',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Colors.blueAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context, timeSlots[index]),
                  child: Text(
                      timeSlots[index],
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primaryColor)
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.primaryColor),),
            )
          ],
        );
      },
    );
  }


  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Update Order Status',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context, 1),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.orange),
              title: const Text('Rescheduled'),
              onTap: () => Navigator.pop(context, 5), // Return 5 for Reschedule
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Completed'),
              onTap: () => Navigator.pop(context, 2),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    ).then((statusType) {
      if (statusType != null) {
        if (statusType == 5) {
          // Trigger the date/time flow if 5 was selected
          _selectDateTime(context);
        } else {
          // Standard update for other statuses
          context.read<OrderStatusBloc>().add(
            UpdateOrderStatusRequested(
              orderId: orderId,
              statusType: statusType,
            ),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () => _showStatusBottomSheet(context),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: MultiBlocListener(
        listeners: [
          // Listener 1: Handle Errors for History Fetching
          BlocListener<OrderHistoryBloc, OrderHistoryState>(
            listener: (context, state) {
              if (state is OrderHistoryError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
          ),
          // Listener 2: Example for Handling Status Updates
          BlocListener<OrderStatusBloc, OrderStatusState>(
            listener: (context, state) {
              if (state is OrderStatusSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Updated successfully!"), backgroundColor: Colors.green),
                );
                // Trigger refresh
                context.read<OrderHistoryBloc>().add(FetchOrderHistoryEvent(userId: 0, orderId: orderId));
              }
            },
          ),

        ],
        child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) return const Center(child: Text('Order not found.'));
              final order = state.orders.first;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummaryCard(order),
                    const SizedBox(height: 20),
                    Text('Items (${order.items.length})',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    ...order.items.map((item) => _buildItemRow(item)).toList(),
                    const SizedBox(height: 20),
                    _buildPricingSection(order),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // --- UI Components ---
  Widget _buildOrderSummaryCard(OrderHistoryModel order) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ${order.orderNumber}',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                OrderReportDialog(orderId: orderId),
              ],
            ),
            const Divider(),
            _buildDetailRow('Status:', order.status, color: Colors.green),
            _buildDetailRow('Order Date:', _formatOrderDate(order.orderDate)),
            _buildDetailRow('Total Amount:', _formatCurrency(order.finalAmount),
                color: Colors.blueAccent, isLarge: true),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(OrderHistoryModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pricing', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPriceRow('Subtotal (Approx)', _formatCurrency(order.finalAmount)),
        _buildPriceRow('Discount', _formatCurrency(0.0), isDiscount: true),
        const Divider(),
        _buildPriceRow('Total Paid', _formatCurrency(order.finalAmount), isTotal: true),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color color = Colors.black87, bool isLarge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
          Text(value, style: GoogleFonts.poppins(
              fontSize: isLarge ? 16 : 14,
              fontWeight: isLarge ? FontWeight.bold : FontWeight.w500,
              color: color
          )),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItemModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4)
            ),
            child: Center(child: Text(item.itemName.substring(0, 1))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('${item.quantity} x ${_formatCurrency(item.unitPrice)}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(_formatCurrency(item.quantity * item.unitPrice),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: GoogleFonts.poppins(
              color: isDiscount ? Colors.red : (isTotal ? Colors.blueAccent : Colors.black),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
          )),
        ],
      ),
    );
  }
}