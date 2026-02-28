import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/PackagesM/package_model.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../pages/package_detail_page.dart';

class AllPackagesPage extends StatefulWidget {
  final List<PackageModel> packages;
  const AllPackagesPage({super.key, required this.packages});

  @override
  State<AllPackagesPage> createState() => _AllPackagesPageState();
}

class _AllPackagesPageState extends State<AllPackagesPage> {
  int _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentUserId = prefs.getInt('user_id') ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Standard breakpoint for tablet
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("All Test Packages",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: widget.packages.isEmpty
          ? const Center(child: Text("No packages available."))
          : isTablet
          ? GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          // Tablet aspect ratio
          childAspectRatio: 1.4,
        ),
        itemCount: widget.packages.length,
        itemBuilder: (context, index) =>
            _buildVerticalPackageCard(widget.packages[index], true),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          return Container(
            // Constrain the height on mobile to prevent layout collapse
            height: 180,
            margin: const EdgeInsets.only(bottom: 16),
            child: _buildVerticalPackageCard(widget.packages[index], false),
          );
        },
      ),
    );
  }

  Widget _buildVerticalPackageCard(PackageModel package, bool isTablet) {
    final cartProvider = context.watch<CartProvider>();

    final int currentQty = cartProvider.qty(package.packageName);
    final bool isItemInCart = currentQty > 0;
    final bool isItemLoading = cartProvider.loadingProductId == package.packageId;

    final String buttonText = isItemInCart ? 'Remove' : 'Add';
    final Color buttonColor = isItemInCart ? Colors.red.shade600 : Colors.blueAccent;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          SlidePageRoute(page: PackageDetailPage(packageId: package.packageId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Using Expanded ensures the content takes up available space
            // above the button container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            package.packageName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 16 : 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${package.details.length} Tests Included',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${package.packagePrice}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Fixed height button container at the bottom
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: TextButton(
                onPressed: isItemLoading
                    ? null
                    : () {
                  if (_currentUserId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to manage your cart.')),
                    );
                    return;
                  }

                  if (isItemInCart) {
                    cartProvider.remove(
                      userId: _currentUserId,
                      labId: package.labId,
                      productId: package.packageId,
                      name: package.packageName,
                      categoryId: 3,
                    );
                  } else {
                    cartProvider.add(
                      userId: _currentUserId,
                      labId: package.labId,
                      productId: package.packageId,
                      name: package.packageName,
                      categoryId: 3,
                      originalPrice: package.packagePrice,
                      discountedPrice: package.packagePrice,
                    );
                  }
                },
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
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}