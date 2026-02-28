class DeviceProduct {
  final String name;
  final String imageUrl;
  final double originalPrice;
  final double discountedPrice;
  final String discountPercentage;
  bool isSaved;
  final String category;
  int qty; // ← track quantity

  DeviceProduct({
    required this.name,
    required this.imageUrl,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.isSaved,
    required this.category,
    this.qty = 0, // default 0
  });
}
