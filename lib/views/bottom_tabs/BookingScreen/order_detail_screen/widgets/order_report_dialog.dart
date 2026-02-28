import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  // Dynamic Save Logic
  Future<void> _handleDownload(BuildContext context, String url, String fileName) async {
    final bool isPdf = url.toLowerCase().endsWith('.pdf');

    try {
      if (isPdf) {
        // PDF Saving logic (to Downloads/Documents folder)
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        final String filePath = "${directory.path}/$fileName";
        await Dio().download(url, filePath);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("PDF saved to Downloads"), backgroundColor: Colors.green),
          );
        }
      } else {
        // Image Saving logic (to Gallery)
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) await Gal.requestAccess();

        var response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        await Gal.putImageBytes(response.data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image saved to Gallery!"), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save failed: $e")));
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

          if (state is OrderDocumentEmpty) {
            return _buildInfoDialog(dialogContext, "Report Not Available", "The report for this order has not been generated or uploaded yet.");
          }

          if (state is OrderDocumentLoaded) {
            final String reportPath = state.document.reportPath ?? "";
            final fileUrl = "${ApiConstants.orderDocumentImageUrl}$reportPath";
            final bool isPdf = reportPath.toLowerCase().endsWith('.pdf');

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              contentPadding: const EdgeInsets.all(16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Report: ${state.document.orderReportNo}",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                          onPressed: () => _handleDownload(context, fileUrl, reportPath),
                          icon: const Icon(Icons.download, color: AppColors.primaryColor)
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Performance Optimized Viewer
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5,
                        ),
                        child: isPdf
                            ? SfPdfViewer.network(fileUrl) // Efficient PDF Rendering
                            : Image.network(
                          fileUrl,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        ),
                      ),
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

          if (state is OrderDocumentError) {
            return _buildInfoDialog(dialogContext, "Error", state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoDialog(BuildContext context, String title, String msg) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 18)),
      content: Text(msg, style: GoogleFonts.poppins(fontSize: 14)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK", style: GoogleFonts.poppins(color: AppColors.primaryColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.read<OrderDocumentBloc>().add(FetchOrderDocument(widget.orderId));
          _showDocumentDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "View Report",
            style: GoogleFonts.poppins(
                color: AppColors.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline
            ),
          ),
        )
    );
  }
}