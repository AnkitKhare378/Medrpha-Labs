import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/bottom_tabs/HomeScreen/pages/package_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/PackagesM/package_model.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../view_model/PackageVM/package_bloc.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../CartScreen/widgets/lab_mismatched_dialog.dart'; // ✅ Added Import
import '../widgets/packages_shimmer_effect.dart';

class LabTestPackages extends StatefulWidget {
  final String labName;
  final int labId;
  const LabTestPackages({super.key, required this.labId, required this.labName});

  @override
  State<LabTestPackages> createState() => _LabTestPackagesState();
}

class _LabTestPackagesState extends State<LabTestPackages> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ Dynamic labId from widget
      create: (context) => PackageBloc()..add(FetchPackages(labId: widget.labId)),
      child: _PopularTestPackagesView(labName: widget.labName, labId: widget.labId),
    );
  }
}

class _PopularTestPackagesView extends StatelessWidget {
  final String labName;
  final int labId;
  const _PopularTestPackagesView({required this.labName, required this.labId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(labName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<PackageBloc, PackageState>(
        builder: (context, state) {
          if (state is PackageLoading) {
            return const Center(child: PackageShimmerEffect());
          } else if (state is PackageError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Failed to load packages: ${state.message}', textAlign: TextAlign.center),
              ),
            );
          } else if (state is PackageLoaded) {
            final packagesToShow = state.packages;

            if (packagesToShow.isEmpty) {
              return const Center(child: Text("No packages found for this lab."));
            }

            return PackageGridView(
                packages: packagesToShow,
                labId: labId,
                labName: labName
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class PackageGridView extends StatefulWidget {
  final List<PackageModel> packages;
  final int labId;
  final String labName; // ✅ Added to pass to dialog

  const PackageGridView({
    super.key,
    required this.packages,
    required this.labId,
    required this.labName
  });

  @override
  State<PackageGridView> createState() => _PackageGridViewState();
}

class _PackageGridViewState extends State<PackageGridView> {
  int _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (mounted) setState(() => _currentUserId = id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: widget.packages.length,
      itemBuilder: (context, index) {
        final package = widget.packages[index];
        final bool isItemInCart = cartProvider.qty(package.packageName) > 0;
        final bool isItemLoading = cartProvider.loadingProductId == package.packageId;

        return InkWell(
          onTap: () => Navigator.of(context).push(
            SlidePageRoute(page: PackageDetailPage(packageId: package.packageId)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.packageName,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${package.details.length} Tests',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const Spacer(),
                        Text(
                          '₹${package.packagePrice}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: isItemLoading ? null : () => _handleCartAction(context, package, isItemInCart),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isItemInCart ? Colors.red.shade600 : Colors.blueAccent,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
                    ),
                    child: isItemLoading
                        ? const Center(
                        child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                    )
                        : Text(
                      isItemInCart ? 'Remove' : 'Add',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleCartAction(BuildContext context, PackageModel package, bool isItemInCart) async {
    if (_currentUserId == 0) {
      Navigator.of(context).push(SlidePageRoute(page: DashboardScreen(initialIndex: 4)));
      context.read<DashboardBloc>().add(DashboardTabChanged(4));
      showAppSnackBar(context, "You firstly need to Login to add package in cart");
      return;
    }

    final cart = context.read<CartProvider>();
    const int categoryId = 3; // Package category
    final int effectiveLabId = package.labId != 0 ? package.labId : widget.labId;

    if (isItemInCart) {
      cart.remove(
          userId: _currentUserId,
          labId: effectiveLabId,
          productId: package.packageId,
          name: package.packageName,
          categoryId: categoryId
      );
    } else {
      try {
        // ✅ Wrap add in try-catch for Mismatch handling
        await cart.add(
            userId: _currentUserId,
            labId: effectiveLabId,
            productId: package.packageId,
            name: package.packageName,
            categoryId: categoryId,
            originalPrice: package.packagePrice,
            discountedPrice: package.packagePrice
        );
      } catch (e) {
        // ✅ Check for LAB_MISMATCH and show dialog
        if (e.toString().contains('LAB_MISMATCH')) {
          showDialog(
            context: context,
            builder: (context) => LabMismatchedDialog(
              cartProvider: cart,
              userId: _currentUserId,
              productId: package.packageId,
              name: package.packageName,
              categoryId: categoryId,
              labId: effectiveLabId,
              labName: widget.labName,
              originalPrice: package.packagePrice,
              discountedPrice: package.packagePrice,
            ),
          );
        } else {
          showAppSnackBar(context, "Failed to add: $e");
        }
      }
    }
  }
}