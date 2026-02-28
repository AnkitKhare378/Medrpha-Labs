// File: lib/data/models/get_cart_model.dart

import 'dart:convert';

/* ===================== RESPONSE ===================== */
class GetCartResponse {
  final List<CartData> data;
  final bool succeeded;
  final String? message;
  final int totalCount;
  final int totalPages;

  GetCartResponse({
    required this.data,
    required this.succeeded,
    this.message,
    required this.totalCount,
    required this.totalPages,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CartData.fromJson(e))
          .toList() ??
          [],
      succeeded: json['succeeded'] ?? false,
      message: json['message'],
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'succeeded': succeeded,
      'message': message,
      'totalCount': totalCount,
      'totalPages': totalPages,
    };
  }
}

/* ===================== CART DATA ===================== */
class CartData {
  final int cartId;
  final int userId;
  final String userName;
  final double totalQuantity;
  final double totalPrice;
  final int categoryId;
  final List<CartItemJson> items;

  CartData({
    required this.cartId,
    required this.userId,
    required this.userName,
    required this.totalQuantity,
    required this.totalPrice,
    required this.categoryId,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    final String itemsJsonString = json['itemsJson'] ?? '[]';
    List<dynamic> itemsList = [];

    try {
      itemsList = jsonDecode(itemsJsonString);
    } catch (e) {
      print('itemsJson parse error: $e');
    }

    return CartData(
      cartId: json['cartId'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] ?? 0,
      items:
      itemsList.map((e) => CartItemJson.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
      'userName': userName,
      'totalQuantity': totalQuantity,
      'totalPrice': totalPrice,
      'categoryId': categoryId,
      // IMPORTANT: items encoded as JSON STRING
      'itemsJson': jsonEncode(items.map((e) => e.toJson()).toList()),
    };
  }
}

/* ===================== CART ITEM ===================== */
class CartItemJson {
  final int productId;
  final double totalQuantity;
  final double price;
  final double discount;
  final double totalPrice;
  final int categoryId;
  final String coupon;
  final String? itemName;
  final String? image;
  final int? storeId;

  CartItemJson({
    required this.productId,
    required this.totalQuantity,
    required this.price,
    required this.discount,
    required this.totalPrice,
    required this.categoryId,
    required this.coupon,
    this.itemName,
    this.image,
    this.storeId,
  });

  factory CartItemJson.fromJson(Map<String, dynamic> json) {
    return CartItemJson(
      productId: json['ProductId'] ?? 0,
      totalQuantity:
      (json['TotalQuantity'] as num?)?.toDouble() ?? 0.0,
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['Discount'] as num?)?.toDouble() ?? 0.0,
      totalPrice:
      (json['TotalPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['CategoryId'] ?? 0,
      coupon: json['Coupon'] ?? '',
      itemName: json['ItemName'],
      image: json['Image'],
      storeId: json['StoreId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'TotalQuantity': totalQuantity,
      'Price': price,
      'Discount': discount,
      'TotalPrice': totalPrice,
      'CategoryId': categoryId,
      'Coupon': coupon,
      if (itemName != null) 'ItemName': itemName,
      if (image != null) 'Image': image,
      if (storeId != null) 'StoreId': storeId,
    };
  }
}
