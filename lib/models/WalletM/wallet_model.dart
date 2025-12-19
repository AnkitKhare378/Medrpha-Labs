// lib/models/wallet_model.dart

class WalletResponse {
  final WalletData? data;
  final String? message;
  final bool succeeded;

  WalletResponse({
    this.data,
    this.message,
    required this.succeeded,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      data: json['data'] != null ? WalletData.fromJson(json['data']) : null,
      message: json['message'],
      succeeded: json['succeeded'] ?? false,
    );
  }
}

class WalletData {
  final int id;
  final int customerId;
  final double currentBalance;
  final bool isActive;

  WalletData({
    required this.id,
    required this.customerId,
    required this.currentBalance,
    required this.isActive,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    // Handle potential null or different types for currentBalance
    final balance = json['currentBalance'];
    double currentBalanceValue = 0.0;
    if (balance is int) {
      currentBalanceValue = balance.toDouble();
    } else if (balance is double) {
      currentBalanceValue = balance;
    }

    return WalletData(
      id: json['id'] ?? 0,
      customerId: json['customerId'] ?? 0,
      currentBalance: currentBalanceValue,
      isActive: json['isActive'] ?? false,
    );
  }
}