import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../view_model/provider/save_for_later_provider.dart';
import '../lab_test_detail_page.dart';

class LabTestCard extends StatelessWidget {
  final Map<String, String> test;

  const LabTestCard({
    super.key,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    final saveForLater = Provider.of<SaveForLaterProvider>(context);
    final isSaved = saveForLater.savedItems.any((item) => item.name == test['name']);
    final name = test["name"]!;
    final price = test["price"]!;
    final originalPrice = test["originalPrice"]!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LabTestDetailPage(test: test),
          ),
        );
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
              child: Container(
                color: Colors.blue.shade50,
                height: 60,
                width: 60,
                child: const Icon(Icons.science, color: Colors.blue, size: 30),
              ),
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
                      GestureDetector(
                        onTap: () {
                          final provider = Provider.of<SaveForLaterProvider>(context, listen: false);
                          if (isSaved) {
                            provider.removeItem(name);
                          } else {
                            provider.addItem(
                              name: name,
                              originalPrice: originalPrice,
                              discountedPrice: price,
                              // imageUrl is omitted/null here, but handled by the provider
                            );
                          }
                        },
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? Colors.blueAccent : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price + Discount
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        originalPrice,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        test["discount"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Fasting info
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        test["fasting"]!,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[700]),
                      ),
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
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey),
                            children: [
                              TextSpan(
                                text: test["lab"]!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement CartProvider logic here
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}