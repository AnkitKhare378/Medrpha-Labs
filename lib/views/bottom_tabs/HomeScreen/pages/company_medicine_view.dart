import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// Ensure these paths match your actual project structure
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/medicine_grid_shimmer.dart';
import '../../../../view_model/MedicineVM/get_medicine_by_store_bloc.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/go_to_cart_bar.dart';
import 'medicine_detail_screen.dart';
import 'widgets/medicine_product_card.dart';

class CompanyMedicineView extends StatelessWidget {
  final int storeId;
  final String companyName;

  const CompanyMedicineView({
    super.key,
    required this.storeId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    // 1. Fetch data on widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GetMedicineByStoreBloc>()
          .add(FetchMedicineByStore(storeId));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          companyName.isNotEmpty ? companyName : "Medicine Store",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // 2. Point BlocBuilder to GetMedicineByStoreBloc
      body: BlocBuilder<GetMedicineByStoreBloc, GetMedicineByStoreState>(
        builder: (context, state) {

          // --- Loading State ---
          if (state is GetMedicineByStoreLoading) {
            return MedicineCardShimmer();
          }

          // --- Error State ---
          if (state is GetMedicineByStoreError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load products',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () => context
                          .read<GetMedicineByStoreBloc>()
                          .add(FetchMedicineByStore(storeId)),
                      child: const Text('Try Again', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          // --- Loaded State ---
          if (state is GetMedicineByStoreLoaded) {
            if (state.medicines.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No medicines found in this store.',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                childAspectRatio: 0.68, // Adjusted for typical product cards
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemCount: state.medicines.length,
              itemBuilder: (context, index) {
                final medicineModel = state.medicines[index];

                return MedicineProductCard(
                  medicine: medicineModel,
                  onTap: () {
                    Navigator.of(context).push(
                      SlidePageRoute(
                        page: MedicineDetailScreen(
                          medicineId: medicineModel.id ?? 0,
                          productName: medicineModel.product ?? "Medicine Details",
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          // --- Initial State ---
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        },
      ),
      bottomNavigationBar: cartCount > 0
          ? GoToCartBar(cartCount: cartCount)
          : null,
    );
  }
}