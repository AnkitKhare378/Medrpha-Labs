import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/widgets/medicine_grid_shimmer.dart';
import '../../../../view_model/MedicineVM/get_medicine_by_company_view_model.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import 'medicine_detail_screen.dart';
import 'widgets/medicine_product_card.dart';

class CompanyMedicineView extends StatelessWidget {
  final int companyId;
  final String companyName;

  const CompanyMedicineView({
    super.key,
    required this.companyId,
    required this.companyName,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<GetMedicineByCompanyBloc>()
          .add(FetchMedicineByCompany(companyId));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Medicine",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<GetMedicineByCompanyBloc, GetMedicineByCompanyState>(
        builder: (context, state) {
          // --- Loading State ---
          if (state is GetMedicineByCompanyLoading) {
            return const Center(child: MedicineCardShimmer());
          }

          // --- Error State ---
          if (state is GetMedicineByCompanyError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text('Failed to load products: ${state.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context
                          .read<GetMedicineByCompanyBloc>()
                          .add(FetchMedicineByCompany(companyId)),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          // --- Loaded State ---
          if (state is GetMedicineByCompanyLoaded) {
            if (state.medicines.isEmpty) {
              return const Center(
                child: Text('No medicines found for this company.',
                    style: TextStyle(fontSize: 16)),
              );
            }

            // Display the list of products in a GridView
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cards per row
                childAspectRatio: 0.6, // Adjust height of the card
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
              ),
              itemCount: state.medicines.length,
              itemBuilder: (context, index) {
                final productModel = state.medicines[index];
                return MedicineProductCard(
                  medicine: productModel,
                  onTap: () {
                    Navigator.of(context).push(
                      SlidePageRoute(
                        page: MedicineDetailScreen(
                          medicineId: productModel.id ?? 0, // Pass the ID here
                          productName: productModel.medicine ?? "", // Pass the name for the title
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          // --- Initial/Unexpected State ---
          return const Center(
              child: Text('Please wait while data is being prepared.'));
        },
      ),
    );
  }
}



