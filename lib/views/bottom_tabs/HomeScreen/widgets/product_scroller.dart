import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medrpha_labs/views/AppWidgets/app_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../view_model/provider/save_for_later_provider.dart';

class ProductScroller extends StatefulWidget {
  ProductScroller({super.key});

  @override
  State<ProductScroller> createState() => _ProductScrollerState();
}

class _ProductScrollerState extends State<ProductScroller> {
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
  }

  final List<Map<String, dynamic>> products = [

    {
      "id": 43,
      "image":
      "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/2X76HlfEq-cetaphil_moisturising_cream_80gm_45835_0_8.jpg",
      "name": "Cetaphil Moisturising Cream 80gm",
      "price": 538.55,
      "cutPrice": 699,
      "discount": 19,
    },
    {
      "id": 44,
      "image":
      "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/F7yhwGWWOo-truuth_crepe_bandage_6_cm_x_4_mtr_1s_472634_0_4.jpg",
      "name": "Truuth Crepe Bandage (6 cm x 4 mtr)",
      "price": 799,
      "cutPrice": 1199,
      "discount": 25,
    },
    {
      "id": 45,
      "image":
      "https://cdn.netmeds.tech/v2/plain-cake-860195/netmed/wrkr/products/assets/item/free/resize-w:180/NSR70YiVDO-cetaphil_sun_spf_50_uvb_uva_very_high_protection_light_gel_50ml_149854_0_5.jpg",
      "name":
      "CETAPHIL SUN SPF 50+ UVB/UVA VERY HIGH PROTECTION LIGHT Gel 50ml",
      "price": 499,
      "cutPrice": 899,
      "discount": 45,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Access provider for reactivity
    final saveProvider = Provider.of<SaveForLaterProvider>(context);

    return Container(
      color: const Color(0xff154D71),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Limited Time Deals",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal product list
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final String name = product['name'] as String;
                final int id = product['id'];

                // 👇 FIX: Check saved status against the new SavedItem object structure (.name)
                final isSaved = saveProvider.savedItems
                    .any((p) => p.id == id);

                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                product["image"] as String,
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Product name
                            Text(
                              name,
                              style: GoogleFonts.poppins(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),

                            // Price row
                            Row(
                              children: [
                                Text(
                                  "₹${product["price"]}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "₹${product["cutPrice"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),

                            // Discount
                            Text(
                              "${product["discount"]}% off",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xff0BA6DF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const Spacer(),

                            // Add button
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement CartProvider add logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: const Size(60, 30),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Add +",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favorite icon
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            if(userId == null){
                              showAppSnackBar(context, "You firstly need to Login to add item in Wishlist");
                            }else {
                              final provider = Provider.of<SaveForLaterProvider>(context, listen: false);
                              if (isSaved) {
                                provider.removeItem(id);
                              } else {
                                provider.addItem(
                                  id: id,
                                  name: name,
                                  originalPrice: product['cutPrice'].toString(), // Original price (cutPrice)
                                  discountedPrice: product['price'].toString(), // Discounted price (price)
                                  imageUrl: product['image'] as String?,
                                );
                              }
                            }

                          },
                          child: Icon(
                            isSaved
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xffc0392b),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}