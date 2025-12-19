// File: lib/data/models/get_cart_model.dart

import 'dart:convert';

class GetCartResponse {
  final List<CartData> data;
  final bool succeeded;
  final String? message;
  final int totalCount;

  GetCartResponse({
    required this.data,
    required this.succeeded,
    this.message,
    required this.totalCount,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CartData.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      succeeded: json['succeeded'] as bool? ?? false,
      message: json['message'] as String?,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

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
    // The itemsJson field is a JSON string, which needs to be parsed first
    List<dynamic> itemsList = [];
    final String itemsJsonString = json['itemsJson'] as String? ?? '[]';
    try {
      itemsList = jsonDecode(itemsJsonString) as List<dynamic>;
    } catch (e) {
      print('Error parsing itemsJson: $e');
    }

    return CartData(
      cartId: json['cartId'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      userName: json['userName'] as String? ?? '',
      totalQuantity: (json['totalQuantity'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['categoryId'] as int? ?? 0,
      items: itemsList
          .map((e) => CartItemJson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CartItemJson {
  final int productId;
  final double totalQuantity;
  final double price;
  final double discount;
  final double totalPrice;
  final int categoryId;
  final String coupon;
  final String? itemName; // Optional field in some array elements

  CartItemJson({
    required this.productId,
    required this.totalQuantity,
    required this.price,
    required this.discount,
    required this.totalPrice,
    required this.categoryId,
    required this.coupon,
    this.itemName,
  });

  factory CartItemJson.fromJson(Map<String, dynamic> json) {
    return CartItemJson(
      productId: json['ProductId'] as int? ?? 0,
      totalQuantity: (json['TotalQuantity'] as num?)?.toDouble() ?? 0.0,
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['Discount'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (json['TotalPrice'] as num?)?.toDouble() ?? 0.0,
      categoryId: json['CategoryId'] as int? ?? 0,
      coupon: json['Coupon'] as String? ?? '',
      itemName: json['ItemName'] as String?,
    );
  }
}