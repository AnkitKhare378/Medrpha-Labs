import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/AppWidgets/app_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 NEW IMPORT
import '../../../../config/apiConstant/api_constant.dart';
import '../../../../data/repositories/wishlist_service/wishlist_service.dart';
import '../../../../models/TestM/lab_test.dart';
import '../../../../pages/dashboard/bloc/dashboard_bloc.dart';
import '../../../../pages/dashboard/bloc/dashboard_event.dart';
import '../../../../view_model/WishlistVM/wishlist_cubit.dart';
import '../../../../view_model/provider/save_for_later_provider.dart';
import '../../../Dashboard/dashboard_screen.dart';
import '../../../Dashboard/widgets/slide_page_route.dart';
import '../../CartScreen/store/cart_notifier.dart';
import '../lab_test_detail_page.dart';

class TestCard extends StatefulWidget {
  final LabTest test;

  const TestCard({
    super.key,
    required this.test,
  });

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  int? _currentUserId;
  bool _isLoadingUserId = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id') ?? 0;

    if (mounted) {
      setState(() {
        _currentUserId = id;
        _isLoadingUserId = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const imageBaseUrl = ApiConstants.testImageBaseUrl;
    if (_isLoadingUserId) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final int userId = _currentUserId!;

    final cart = Provider.of<CartProvider>(context);
    final int itemQtyInCart = cart.qty(widget.test.testName);

    final int productId = widget.test.testID;
    const int categoryId = 0;

    final saveForLater = Provider.of<SaveForLaterProvider>(context, listen: false);
    final initialIsSaved = saveForLater.savedItems.any((item) => item.name == widget.test.testName);
    final bool isThisProductLoading = cart.isProductLoading(productId);
    final name = widget.test.testName;
    final id = productId;
    final price = "₹${widget.test.testPrice.toStringAsFixed(0)}";
    const String originalPriceString = "₹700";
    const String discountedPriceString = "₹350";
    const String discount = "50% OFF";
    const String fasting = "10-12 hours fasting required";
    const String labName = "Apollo Lab";

    return BlocProvider(
      create: (context) => WishlistCubit(
        WishlistService(),
        initialIsSaved,
        userId,
        productId,
        categoryId,
      ),
      child: BlocListener<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state is WishlistLoaded) {
            final localProvider = Provider.of<SaveForLaterProvider>(context, listen: false);
            if (state.isWished) {
              localProvider.addItem(
                id: id,
                name: name,
                originalPrice: originalPriceString,
                discountedPrice: discountedPriceString,
              );
            } else {
              localProvider.removeItem(id);
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(SlidePageRoute(page: LabTestDetailPage(testId: widget.test.testID,)),);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network("$imageBaseUrl${widget.test.testImage}", height: 60,width: 60, fit: BoxFit.cover,)
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Consumer<SaveForLaterProvider>(
                            builder: (context, saveForLaterProvider, child) {
                              final int currentProductId = widget.test.testID;
                              final bool providerIsSaved = saveForLaterProvider.isSaved(currentProductId);
                              return BlocListener<WishlistCubit, WishlistState>(
                                listener: (context, state) {
                                  if (state is WishlistLoaded) {
                                    showAppSnackBar(context, state.message);
                                  } else if (state is WishlistError) {
                                    showAppSnackBar(context, state.message);
                                  }
                                },
                                child: BlocBuilder<WishlistCubit, WishlistState>(
                                  builder: (context, state) {
                                    final bool isWished = state is WishlistLoaded
                                        ? state.isWished
                                        : providerIsSaved;

                                    final bool isLoading = state is WishlistLoading;
                                    final cubit = context.read<WishlistCubit>();

                                    if (isLoading) {
                                      return const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Center(
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent)
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        if(userId == 0){
                                          Navigator.of(context).push(SlidePageRoute(page: DashboardScreen(initialIndex: 4),));
                                          context.read<DashboardBloc>().add( DashboardTabChanged(4));
                                          showAppSnackBar(context, "You firstly need to Login to use WishList");
                                        }
                                        else{
                                          cubit.toggleWishlist();
                                        }
                                      },
                                      child: Icon(
                                        isWished ? Icons.bookmark : Icons.bookmark_border,
                                        color: isWished ? Colors.blueAccent : Colors.grey,
                                        size: 20,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Price + Discount
                      Row(
                        children: [
                          Text(price, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Text(originalPriceString, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 6),
                          Text(discount, style: GoogleFonts.poppins(fontSize: 13, color: Colors.pink, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Fasting info
                      Row(
                        children: [
                          const Icon(Icons.restaurant_menu, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(fasting, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Lab name + Add Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "By ",
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: widget.test.testSynonym?.name,
                                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if(userId != 0) ...[
                            if (isThisProductLoading)
                              const SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: CircularProgressIndicator(strokeWidth: 2.5),
                                ),
                              )
                            else if (itemQtyInCart == 0)
                              ElevatedButton.icon(
                                onPressed: isThisProductLoading ? null : () {
                                  cart.add(
                                    categoryId: 2,
                                    userId: userId,
                                    productId: productId,
                                    name: name,
                                    originalPrice: originalPriceString,
                                    discountedPrice: discountedPriceString,
                                  );
                                },
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text("Add"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: GoogleFonts.poppins(fontSize: 13),
                                ),
                              )
                            else
                              ElevatedButton.icon(
                                onPressed: isThisProductLoading ? null : () {
                                  cart.remove(
                                    categoryId: 2,
                                    userId: userId,
                                    productId: productId,
                                    name: name,
                                  );
                                },
                                icon: const Icon(Icons.remove, size: 16),
                                label: const Text("Remove"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                          ],
                          if(userId == 0) ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(SlidePageRoute(page: DashboardScreen(initialIndex: 4),));
                                context.read<DashboardBloc>().add( DashboardTabChanged(4));
                                showAppSnackBar(context, "You firstly need to Login to add test in cart");
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text("Add"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                textStyle: GoogleFonts.poppins(fontSize: 13),
                              ),
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
