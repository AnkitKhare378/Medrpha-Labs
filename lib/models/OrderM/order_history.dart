import 'dart:convert';

class OrderHistoryResponseModel {
  final List<OrderHistoryModel> data;
  final int totalCount;
  final int totalPages; // ⬅️ Includes previously added field
  final bool succeeded;
  final String? message;

  OrderHistoryResponseModel({
    required this.data,
    required this.totalCount,
    required this.totalPages,
    required this.succeeded,
    this.message,
  });

  factory OrderHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle potential null/empty data list safely
    final dataList = json['data'] as List?;

    return OrderHistoryResponseModel(
      data: dataList
          ?.map((i) => OrderHistoryModel.fromJson(i as Map<String, dynamic>))
          .toList() ?? [], // Provide an empty list as a default
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] as int? ?? 0, // Parsed totalPages
      succeeded: json['succeeded'] ?? false,
      message: json['message'] as String?, // Cast to nullable String
    );
  }
}

class OrderHistoryModel {
  final int orderId;
  final String orderNumber;
  final DateTime orderDate;
  final int orderStatus;
  final int paymentStatus;
  final int paymentMethod;
  final double subTotal;
  final double discountAmount;
  final double finalAmount;
  final String status;

  // New Address Fields
  final String addressTitle;
  final String flatHouseNumber;
  final String street;
  final String locality;
  final String pincode;
  final double latitude;
  final double longitude;

  final List<OrderItemModel> items;

  OrderHistoryModel({
    required this.orderId,
    required this.orderNumber,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.subTotal,
    required this.discountAmount,
    required this.finalAmount,
    required this.status,
    required this.addressTitle,
    required this.flatHouseNumber,
    required this.street,
    required this.locality,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.items,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    // 1. Handle the double-encoded itemsJson string
    final String itemsJsonString = json['itemsJson'] as String? ?? '[]';
    final List<dynamic> itemsList = jsonDecode(itemsJsonString);

    // 2. Helper to handle potential String-to-Int conversion from the API
    int safeParseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return OrderHistoryModel(
      orderId: json['orderId'] as int? ?? 0,
      orderNumber: json['orderNumber'] as String? ?? 'N/A',
      orderDate: DateTime.tryParse(json['orderDate'] as String? ?? '') ?? DateTime.now(),
      orderStatus: safeParseInt(json['orderStatus']),
      paymentStatus: safeParseInt(json['paymentStatus']),
      paymentMethod: safeParseInt(json['paymentMethod']),
      subTotal: (json['subTotal'] as num? ?? 0.0).toDouble(),
      discountAmount: (json['discountAmount'] as num? ?? 0.0).toDouble(),
      finalAmount: (json['finalAmount'] as num? ?? 0.0).toDouble(),
      status: json['status'] as String? ?? 'Unknown',

      // Mapping the new address fields
      addressTitle: json['addressTitle'] as String? ?? '',
      flatHouseNumber: json['faltHousNumber'] as String? ?? '', // Note: kept 'falt' to match JSON typo
      street: json['street'] as String? ?? '',
      locality: json['locality'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      latitude: (json['latitude'] as num? ?? 0.0).toDouble(),
      longitude: (json['longitude'] as num? ?? 0.0).toDouble(),

      items: itemsList
          .map((i) => OrderItemModel.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderItemModel {
  final int productId;
  final int orderItemId;
  final String itemName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final int labId;

  OrderItemModel({
    required this.productId,
    required this.orderItemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.labId,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['ProductId'] as int? ?? 0,
      orderItemId: json['OrderItemId'] as int? ?? 0,
      itemName: json['itemName'] as String? ?? 'Item N/A', // Null safety for String
      quantity: json['Quantity'] as int? ?? 0,
      labId: json['LabId'] as int? ?? 0,
      unitPrice: (json['UnitPrice'] as num? ?? 0.0).toDouble(), // Null safety for double
      totalPrice: (json['TotalPrice'] as num? ?? 0.0).toDouble(), // Null safety for double
    );
  }
}

class OrderFilters {
  String? status; // 'On the way', 'Delivered', etc.
  String? timeRange; // 'Last 30 days', '2024', etc.

  OrderFilters({this.status, this.timeRange});

  bool get isEmpty => status == null && timeRange == null;

  void clear() {
    status = null;
    timeRange = null;
  }
}