import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medrpha_labs/views/bottom_tabs/BookingScreen/order_detail_screen/widgets/order_report_dialog.dart';
import '../../../../config/color/colors.dart';
import '../../../../data/repositories/order_service/order__history_service.dart';
import '../../../../models/OrderM/order_history.dart';
import '../../../../view_model/CartVM/store_shift_bloc.dart';
import '../../../../view_model/OrderVM/OrderHistory/order_history_bloc.dart';
import '../../../../view_model/OrderVM/OrderHistory/order_status_view_model.dart';
import '../../CartScreen/widgets/slot_card.dart';

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
              userId:  0,
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


  Future<void> _selectDateTime(BuildContext context) async {
    final historyState = context.read<OrderHistoryBloc>().state;
    if (historyState is! OrderHistoryLoaded || historyState.orders.isEmpty) return;

    final order = historyState.orders.first;
    // Use labId or storeId as per your model
    final int storeId = order.items.isNotEmpty ? order.items.first.labId : 0;

    if (storeId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Store info missing")));
      return;
    }

    String? capturedIsoDate; // Local variable to store date from SlotCard
    String? finalFormattedTime;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<StoreShiftBloc>(),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Reschedule Order', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16)),
            content: SizedBox(
              width: double.maxFinite,
              child: SlotCard(
                storeId: storeId,
                forOrder: true,
                onDateSelected: (isoDate) {
                  capturedIsoDate = isoDate; // Sync selected date
                },
                onTimeSelected: (formattedTime) {
                  finalFormattedTime = formattedTime;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  if (finalFormattedTime != null) {
                    Navigator.pop(dialogContext, true);
                  } else {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text("Please select a time slot")),
                    );
                  }
                },
                child: Text('Confirm', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    ).then((confirmed) {
      if (confirmed == true && finalFormattedTime != null) {
        // Use picked date from SlotCard, or fallback to current time
        final String orderDateToSend = capturedIsoDate ?? DateTime.now().toUtc().toIso8601String();

        context.read<OrderStatusBloc>().add(
          UpdateOrderStatusRequested(
            orderId: orderId,
            statusType: 5,
            orderDate: orderDateToSend, // Dynamic selected date
            orderTime: finalFormattedTime!, // HH:mm:ss
          ),
        );
      }
    });
  }

  // Modified to return a bool so the parent can decide whether to close
  Future<bool?> _showSlotConfirmationDialog(BuildContext context, String selectedTime) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Confirm Time Slot',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to schedule this order for $selectedTime?',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Change', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Confirm', style: GoogleFonts.poppins(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<bool> _showCancelConfirmationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Cancel Order',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'No, Keep It',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // Red to indicate cancellation
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          )
        ],
      ),
    );
    return result ?? false;
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
            // ListTile(
            //   leading: const Icon(Icons.check_circle, color: Colors.green),
            //   title: const Text('Completed'),
            //   onTap: () => Navigator.pop(context, 2),
            // ),
            const SizedBox(height: 8),
          ],
        );
      },
    ).then((statusType) async {
      if (statusType == null) return;

      if (statusType == 5) {
        // Flow for Reschedule
        _selectDateTime(context);
      } else if (statusType == 1) {
        // 🎯 Trigger Confirmation Dialog for Cancel
        final bool confirmed = await _showCancelConfirmationDialog(context);
        if (confirmed && context.mounted) {
          context.read<OrderStatusBloc>().add(
            UpdateOrderStatusRequested(
              orderId: orderId,
              statusType: 1, orderDate: '', orderTime: '',
            ),
          );
        }
      } else {
        // Standard update for any other statuses
        context.read<OrderStatusBloc>().add(
          UpdateOrderStatusRequested(
            orderId: orderId,
            statusType: statusType, orderDate: '', orderTime: '',
          ),
        );
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
          // Wrap the button in a BlocBuilder to access the order status
          BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
            builder: (context, state) {
              if (state is OrderHistoryLoaded && state.orders.isNotEmpty) {
                final order = state.orders.first;

                // Logic: Only show the button if status is NOT 'Completed'
                if (order.status != 'Completed') {
                  return IconButton(
                    icon: const Icon(Icons.edit_note),
                    onPressed: () => _showStatusBottomSheet(context),
                  );
                }
              }
              // Return an empty widget (or SizedBox) if loading, error, or Completed
              return const SizedBox.shrink();
            },
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
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ${order.orderNumber}',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                OrderReportDialog(orderId: order.orderId), // Fixed to use order object
              ],
            ),
            const Divider(),
            _buildDetailRow('Status:', order.status, color: Colors.green),
            _buildDetailRow('Order Date:', _formatOrderDate(order.orderDate)),

            // --- Added Delivery Address Section ---
            const SizedBox(height: 8),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   order.addressTitle.trim().isEmpty ? 'Delivery Address' : order.addressTitle,
                      //   style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
                      // ),
                      Text(
                        '${order.flatHouseNumber}, ${order.street}, ${order.locality} - ${order.pincode}',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            // --------------------------------------

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
        Text('Pricing', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
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
                Text(item.itemName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 12)),
                Text('${item.quantity} x ${_formatCurrency(item.unitPrice)}',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(_formatCurrency(item.quantity * item.unitPrice),
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
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
          Text(label, style: GoogleFonts.poppins(fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal)),
          Text(value, style: GoogleFonts.poppins(
              color: isDiscount ? Colors.red : (isTotal ? Colors.blueAccent : Colors.black),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal
          )),
        ],
      ),
    );
  }
}