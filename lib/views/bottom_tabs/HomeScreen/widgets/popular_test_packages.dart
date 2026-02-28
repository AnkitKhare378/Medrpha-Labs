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
import '../all_pages/all_packages_page.dart';
import 'packages_shimmer_effect.dart';

class PopularTestPackages extends StatelessWidget {
  const PopularTestPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc()..add(FetchPackages(labId: 0)),
      child: const _PopularTestPackagesView(),
    );
  }
}

class _PopularTestPackagesView extends StatelessWidget {
  const _PopularTestPackagesView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Blood Test Packages',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            BlocBuilder<PackageBloc, PackageState>(
              builder: (context, state) {
                if (state is PackageLoaded && state.packages.isNotEmpty) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(page: AllPackagesPage(packages: state.packages)),
                      );
                    },
                    child: Text(
                      "View All",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(height: 15),

        BlocBuilder<PackageBloc, PackageState>(
          builder: (context, state) {
            if (state is PackageLoading) {
              return const Center(child: PackageShimmerEffect());
            } else if (state is PackageError) {
              return Center(
                  child: Text(
                      'Oops! Failed to load packages. Server\'s on a coffee break? \n(${state.message})'));
            } else if (state is PackageLoaded) {
              return PackageListView(packages: state.packages);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class PackageListView extends StatefulWidget {
  final List<PackageModel> packages;

  const PackageListView({super.key, required this.packages});

  @override
  State<PackageListView> createState() => _PackageListViewState();
}

class _PackageListViewState extends State<PackageListView> {
  int _currentUserId = 0;
  int displayLimit = 6;
  late bool hasMore = widget.packages.length > displayLimit;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    if (mounted) {
      setState(() {
        _currentUserId = id ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isTablet = screenWidth >= 600;

    // ✅ MOBILE = OLD UI
    final double cardWidth =
    isTablet ? screenWidth * 0.32 : screenWidth * 0.43;

    final double listHeight =
    isTablet ? screenHeight * 0.30 : screenHeight * 0.24;

    final double bookNowHeight =
    isTablet ? screenHeight * 0.055 : screenHeight * 0.05;

    if (widget.packages.isEmpty) {
      return const Center(child: Text('No packages available right now.'));
    }

    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          final String testCount = '${package.details.length} Tests';
          final String offerPrice = '₹${package.packagePrice}';

          // ✅ Fonts: OLD for mobile, NEW for tablet
          final double titleFontSize =
          isTablet ? 18 : 14;

          final double subTextFontSize =
          isTablet ? 15 : 12;

          final double priceFontSize =
          isTablet ? 15 : 12;

          final double buttonFontSize =
          isTablet ? 16 : 14;

          final int currentQty = cartProvider.qty(package.packageName);
          final bool isItemInCart = currentQty > 0;
          final bool isItemLoading =
              cartProvider.loadingProductId == package.packageId;

          final String buttonText = isItemInCart ? 'Remove' : 'Add';
          final Color buttonColor =
          isItemInCart ? Colors.red.shade600 : Colors.blueAccent;

          void handleCartAction() {
            if (_currentUserId == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please log in to manage your cart.'),
                ),
              );
              return;
            }

            final cart = context.read<CartProvider>();

            if (isItemInCart) {
              cart.remove(
                userId: _currentUserId,
                labId: package.labId,
                productId: package.packageId,
                name: package.packageName,
                categoryId: 3,
              );
            } else {
              cart.add(
                userId: _currentUserId,
                labId: package.labId,
                productId: package.packageId,
                name: package.packageName,
                categoryId: 3,
                originalPrice: package.packagePrice,
                discountedPrice: package.packagePrice,
              );
            }
          }

          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                SlidePageRoute(
                  page: PackageDetailPage(
                    packageId: package.packageId,
                  ),
                ),
              );
            },
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: isTablet ? 8 : 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(isTablet ? 14 : 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.packageName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: titleFontSize,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          testCount,
                          style: GoogleFonts.poppins(
                            fontSize: subTextFontSize,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 10 : 8,
                            vertical: isTablet ? 6 : 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Exclusive offer $offerPrice',
                            style: GoogleFonts.poppins(
                              fontSize: priceFontSize,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  Container(
                    height: bookNowHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(isTablet ? 16 : 12),
                      ),
                    ),
                    child: TextButton(
                      onPressed: isItemLoading
                          ? null
                          : (_currentUserId != 0
                          ? handleCartAction
                          : () {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: DashboardScreen(initialIndex: 4),
                          ),
                        );
                        context
                            .read<DashboardBloc>()
                            .add(DashboardTabChanged(4));
                        showAppSnackBar(
                          context,
                          "You firstly need to Login to add package in cart",
                        );
                      }),
                      child: isItemLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: buttonFontSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
