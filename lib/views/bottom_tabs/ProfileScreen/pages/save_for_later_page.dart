import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/apiConstant/api_constant.dart';
import '../../../../models/WishlistM/wishlist_model.dart';
import '../../../../view_model/WishlistVM/get_wishlist_bloc.dart';
import '../../../../view_model/WishlistVM/get_wishlist_event.dart';
import '../../../../view_model/WishlistVM/get_wishlist_state.dart';
import '../../../../data/repositories/wishlist_service/wishlist_service.dart';
import '../../../../view_model/WishlistVM/wishlist_cubit.dart';
import '../../../../view_model/provider/save_for_later_provider.dart';
import '../../../AppWidgets/app_snackbar.dart';
import '../widgets/wishlist_shimmer_loader.dart'; // Assuming this path is correct

class SaveForLaterPage extends StatefulWidget {
  const SaveForLaterPage({super.key});

  static const String _defaultPlaceholderUrl = 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';

  @override
  State<SaveForLaterPage> createState() => _SaveForLaterPageState();
}

class _SaveForLaterPageState extends State<SaveForLaterPage> {
  int? userId;

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
        userId = id;
      });
    }

    if (id == null) {
      debugPrint('⚠️ User ID not found in local storage. Cannot load wishlist.');
    } else {
      // Trigger the initial wishlist fetch ONLY AFTER the ID is loaded
      context.read<GetWishlistBloc>().add(FetchWishlist(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<GetWishlistBloc>().add( FetchWishlist(userId!));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Wishlist', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<GetWishlistBloc, GetWishlistState>(
        builder: (context, state) {
          if (state is GetWishlistLoading) {
            return const WishlistShimmerLoader();
          }
          if (state is GetWishlistError) {
            return _errorSection(context, state.message);
          }
          if (state is GetWishlistLoaded) {
            final items = state.items;
            return items.isEmpty ? _emptySection() : _buildWishlist(context, items);
          }

          // Initial or other unhandled states
          return const Center(child: Text('Pull to load wishlist.'));
        },
      ),
    );
  }

  Widget _buildWishlist(BuildContext context, List<WishlistItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item.productId == null) {
          return const SizedBox.shrink(); // Skip item if necessary data is missing
        }

        return BlocProvider(
          create: (_) => WishlistCubit(
            WishlistService(), // Instantiates the service to call the API
            true,
            userId!,
            item.productId!,
            item.categoryId ?? 1, // Use a default categoryId if null
          ),
          child: _SavedItemCardWithCubit(
            item: item,
            onMoveToCart: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Moving ${item.name} to cart... (Not implemented)')),
              );
            }, userId: userId,
          ),
        );
      },
    );
  }

  Widget _emptySection() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text('Your Wishlist is Empty!',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Tap the heart icon on products to save them here.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center),
          SizedBox(height: 100,)
        ],
      ),
    ),
  );

  Widget _errorSection(BuildContext context, String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text('Failed to Load Wishlist',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Error: $message',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<GetWishlistBloc>().add(FetchWishlist(userId ?? 0)),
            child: const Text('Try Again'),
          )
        ],
      ),
    ),
  );
}

class _SavedItemCardWithCubit extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onMoveToCart;
  final int? userId;

  const _SavedItemCardWithCubit({
    required this.item,
    required this.onMoveToCart,
    required this.userId,
  });

  Widget _cardContent({
    required BuildContext context,
    required String title,
    required String price,
    required String imageUrl,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.blue.shade100.withOpacity(0.4), blurRadius: 6)],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(price, style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // TextButton(onPressed: onMoveToCart, child: Text('Move to Cart', style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13),)),
                      // The REMOVE button now calls the onRemove action
                      TextButton(onPressed: onRemove, child: Text('Remove', style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(item.imageUrl);
    const imageBaseUrl = ApiConstants.testImageBaseUrl;
    final imageUrl = item.imageUrl != null && item.imageUrl!.isNotEmpty
        ? '$imageBaseUrl${item.imageUrl}'
        : null;
    // BlocListener listens for a successful removal event from the local WishlistCubit
    return BlocListener<WishlistCubit, WishlistState>(
      listener: (context, state) {
        if (state is WishlistLoaded) {
          if (!state.isWished) {
            showAppSnackBar(context, state.message);
            try {
              final localProvider = context.read<SaveForLaterProvider>();
              localProvider.removeItem(item.productId);
            } catch (e) {
              print("Warning: Could not remove item from local SaveForLaterProvider: $e");
            }
            context.read<GetWishlistBloc>().add(FetchWishlist(userId ?? 0));
          }
        } else if (state is WishlistError) {
          showAppSnackBar(context, state.message);
        }
      },
      child: _cardContent(
        context: context,
        title: item.name ?? 'Product ID ${item.productId}',
        price: '₹ 250.00',
        // price: '₹${item.discountedPrice?.toStringAsFixed(2) ?? '250.00'}',
        imageUrl: imageUrl ?? SaveForLaterPage._defaultPlaceholderUrl,
        onRemove: () {
          context.read<WishlistCubit>().toggleWishlist();
        },
      ),
    );
  }
}