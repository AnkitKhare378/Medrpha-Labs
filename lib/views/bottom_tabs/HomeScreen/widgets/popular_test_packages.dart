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
import 'packages_shimmer_effect.dart';

class PopularTestPackages extends StatelessWidget {
  const PopularTestPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc()..add(FetchPackages()),
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
        Text(
          'Popular Blood Test Packages',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
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

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  // Helper function to load User ID only once
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
    final double cardWidth = screenWidth * 0.43;
    final double bookNowHeight = screenHeight * 0.05;

    if (widget.packages.isEmpty) {
      return const Center(child: Text('No packages available right now.'));
    }

    return SizedBox(
      height: screenHeight * 0.24,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          final String testCount = '${package.details.length} Tests';
          final String offerPrice = '₹${package.packagePrice}';

          final int currentQty = cartProvider.qty(package.packageName);
          final bool isItemInCart = currentQty > 0;
          final bool isItemLoading = cartProvider.loadingProductId == package.packageId;

          // Determine button display based on cart status
          final String buttonText = isItemInCart ? 'Remove' : 'Add';
          final Color buttonColor = isItemInCart ? Colors.red.shade600 : Colors.blueAccent;

          // Define the action function to handle both Add and Remove
          void handleCartAction() {
            if (_currentUserId == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please log in to manage your cart.')),
              );
              return;
            }

            final cart = context.read<CartProvider>();

            if (isItemInCart) {
              cart.remove(
                userId: _currentUserId,
                productId: package.packageId,
                name: package.packageName,
                categoryId: 3,
              );
            } else {
              cart.add(
                userId: _currentUserId,
                productId: package.packageId,
                name: package.packageName,
                categoryId: 3,
                originalPrice: package.packagePrice.toString(), // Assuming mrpPrice is available
                discountedPrice: package.packagePrice.toString(), // Using packagePrice as discounted
              );
            }
          }


          return InkWell(
            onTap: (){
              Navigator.of(context).push(
                SlidePageRoute(
                  page: PackageDetailPage(packageId: package.packageId),
                ),
              );
            },
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.packageName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          testCount,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Exclusive offer $offerPrice',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
            
                  if(_currentUserId != 0) ...[
                    Container(
                      height: bookNowHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: buttonColor, // Dynamic color
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: TextButton(
                        onPressed: isItemLoading ? null : handleCartAction,
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
                          buttonText, // Dynamic text
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if(_currentUserId == 0) ...[
                    Container(
                      height: bookNowHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: buttonColor, // Dynamic color
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(SlidePageRoute(page: DashboardScreen(initialIndex: 4),));
                          context.read<DashboardBloc>().add( DashboardTabChanged(4));
                          showAppSnackBar(context, "You firstly need to Login to add package in cart");
                        },
                        child: Text(
                          "Add", // Dynamic text
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}