import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../config/apiConstant/api_constant.dart';
import '../../../../../config/color/colors.dart';
import '../../../../../view_model/OrderVM/OrderHistory/order_document_view_model.dart';

class OrderReportDialog extends StatefulWidget {
  final int orderId;
  const OrderReportDialog({super.key, required this.orderId});

  @override
  State<OrderReportDialog> createState() => _OrderReportDialogState();
}

class _OrderReportDialogState extends State<OrderReportDialog> {

  // Method to download and save image
  Future<void> _saveImage(BuildContext context, String url) async {
    try {
      // Check/Request permission using gal's built-in method
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      // Download bytes with Dio
      var response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save to gallery
      final Uint8List bytes = Uint8List.fromList(response.data);
      await Gal.putImageBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved to Gallery!"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _showDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<OrderDocumentBloc, OrderDocumentState>(
        builder: (context, state) {
          if (state is OrderDocumentLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          }
          if (state is OrderDocumentLoaded) {
            final imageUrl = "${ApiConstants.orderDocumentImageUrl}${state.document.reportPath}";

            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          state.document.orderReportNo,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                          onPressed: () => _saveImage(context, imageUrl),
                          icon: const Icon(Icons.download, color: AppColors.primaryColor)
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text("Close", style: GoogleFonts.poppins(color: AppColors.primaryColor))
                )
              ],
            );
          }
          // ... (rest of your state handling)
          return const SizedBox();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<OrderDocumentBloc>().add(FetchOrderDocument(widget.orderId));
        _showDocumentDialog(context);
      },
      child: Image.network(
        "https://cdn-icons-png.flaticon.com/128/11411/11411445.png",
        height: 30,
      ),
    );
  }
}