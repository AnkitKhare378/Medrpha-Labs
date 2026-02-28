class CartItem {
  final int productId;
  final String name;
  final String image;
  final int qty;
  final double originalPrice;
  final double discountedPrice;
  final int categoryId;

  CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.qty,
    required this.originalPrice,
    required this.discountedPrice,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'image': image,
    'qty': qty,
    'originalPrice': originalPrice,
    'discountedPrice': discountedPrice,
    'categoryId': categoryId,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      name: map['name'],
      image: map['image'] ?? '',
      qty: map['qty'],
      originalPrice: (map['originalPrice'] as num).toDouble(),
      discountedPrice: (map['discountedPrice'] as num).toDouble(),
      categoryId: map['categoryId'],
    );
  }
}
