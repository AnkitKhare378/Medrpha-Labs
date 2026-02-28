import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/repositories/medicine_service/medicine_by_Id_service.dart';
import '../../../../view_model/MedicineVM/medicine_detail_view_model.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/go_to_cart_bar.dart';
import 'medicine_detail_content_manager.dart';

class MedicineDetailScreen extends StatelessWidget {
  final int medicineId;
  final String productName;

  const MedicineDetailScreen({
    super.key,
    required this.medicineId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return BlocProvider(
      create: (context) => MedicineDetailCubit(MedicineService())
        ..fetchMedicineDetail(medicineId), // Start fetching data
      child: Scaffold(
        // **CRITICAL FIX 1: Set a background color for the Scaffold**
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Medicine Details",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        // The manager will handle the loading/shimmer/error/loaded states
        body: const MedicineDetailContentManager(),
        bottomNavigationBar: cartCount > 0
            ? GoToCartBar(cartCount: cartCount)
            : null,
      ),
    );
  }
}