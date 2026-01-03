import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/repositories/medicine_service/category_medicine_service.dart';
import '../../../../view_model/MedicineVM/category_medicine_bloc.dart';
import '../widgets/category_medicine_product_card.dart';

class CategoryMedicineView extends StatefulWidget {
  final int id; // Category or Brand ID
  final String title; // Page Title (e.g., "Cipla" or "Fever")
  final MedicineFetchType fetchType;

  const CategoryMedicineView({
    super.key,
    required this.id,
    required this.title,
    required this.fetchType,
  });

  @override
  State<CategoryMedicineView> createState() => _CategoryMedicineViewState();
}

class _CategoryMedicineViewState extends State<CategoryMedicineView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryMedicineBloc(CategoryMedicineService())
        ..add(FetchMedicines(id: widget.id, type: widget.fetchType)),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: BlocBuilder<CategoryMedicineBloc, CategoryMedicineState>(
            builder: (context, state) {
              if (state is CategoryMedicineLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
              }

              if (state is CategoryMedicineError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(state.message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(color: Colors.red)),
                  ),
                );
              }

              if (state is CategoryMedicineLoaded) {
                if (state.medicines.isEmpty) {
                  return Center(
                    child: Text(
                      "No medicines found for this ${widget.fetchType.name}.",
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65, // Adjust based on your card height
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: state.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = state.medicines[index];
                    return CategoryMedicineProductCard(
                      medicine: medicine,
                      onTap: () {
                        // Navigate to detail if needed
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}