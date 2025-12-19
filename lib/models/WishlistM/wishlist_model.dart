class WishlistItem {
  final int id;
  final int userId;
  final int productId;
  final DateTime addedDate;
  final int categoryId;
  final String? name;
  final double? discountedPrice;
  final String? imageUrl;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.addedDate,
    required this.categoryId,
    this.name,
    this.discountedPrice,
    this.imageUrl,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      addedDate: DateTime.parse(json['addedDate'] as String),
      categoryId: json['categoryId'] as int,
      // Default placeholder values for product details
      name: '${json['testName']}',
      discountedPrice: 0.00,
      imageUrl: json['testImage'] as String,
    );
  }
}