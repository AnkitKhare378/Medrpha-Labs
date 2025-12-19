import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/config/color/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/routes_name.dart';
import '../../../../data/repositories/package_service/package_detail_service.dart';
import '../../../../view_model/PackageVM/package_detail_view_model.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../widgets/package_detail_shimmer.dart';
import '../widgets/package_detail_widgets.dart';

class PackageDetailPage extends StatelessWidget {
  final int packageId;

  const PackageDetailPage({super.key, required this.packageId});

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    return BlocProvider(
      create: (context) => PackageDetailBloc(PackageDetailService())
        ..add(FetchPackageDetail(packageId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Package Details",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Search bar
              const PackageDetailSearchBar(),

              // Content based on BLoC state
              BlocBuilder<PackageDetailBloc, PackageDetailState>(
                builder: (context, state) {
                  if (state is PackageDetailLoading) {
                    return const PackageDetailShimmer();
                  }
                  if (state is PackageDetailError) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(
                          "Error: Failed to load package details. ${state.message}",
                          style: GoogleFonts.poppins(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  if (state is PackageDetailLoaded) {
                    return PackageDetailLoadedContent(detail: state.packageDetail);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: cartCount > 0
            ? Container(
          margin: const EdgeInsets.all(16),
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$cartCount item${cartCount > 1 ? 's' : ''} in cart',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, RoutesName.cartScreen),
                  child: Text(
                    'Go to Cart',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : null,
      ),
    );
  }

}

