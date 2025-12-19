class ProductItem {
  final String name;
  final String imageUrl;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercentage;
  bool isSaved;

  ProductItem({
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.isSaved,
  });
}
