// models/payment_method_model.dart

/// Represents a single payment method returned from the API.
class PaymentMethodModel {
  final int id;
  final String paymenName;
  final String discraption;
  final bool isActive;
  // Ignoring created_by, created_date, modified_by, modified_date for simplicity

  PaymentMethodModel({
    required this.id,
    required this.paymenName,
    required this.discraption,
    required this.isActive,
  });

  /// Factory constructor to create a PaymentMethodModel from a JSON map.
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as int,
      paymenName: json['paymenName'] as String,
      discraption: json['discraption'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  // Optionally add a toString for easy debugging
  @override
  String toString() {
    return 'PaymentMethodModel(id: $id, paymenName: $paymenName, isActive: $isActive)';
  }
}

/// Utility class to hold the list of payment methods.
class PaymentMethodList {
  final List<PaymentMethodModel> methods;

  PaymentMethodList({required this.methods});

  /// Factory constructor to create a list from the API response (a list of maps).
  factory PaymentMethodList.fromListJson(List<dynamic> jsonList) {
    List<PaymentMethodModel> methods = jsonList
        .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaymentMethodList(methods: methods);
  }
}