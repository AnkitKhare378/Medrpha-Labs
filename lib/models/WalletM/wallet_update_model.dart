// lib/models/UpdateWalletM/update_wallet_model.dart

class UpdateWalletRequestModel {
  final int userId;
  final double currentBalance;

  UpdateWalletRequestModel({
    required this.userId,
    required this.currentBalance,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "currentBalance": currentBalance,
    };
  }
}

class UpdateWalletResponseModel {
  final UpdateWalletData data;
  final String message;
  final bool succeeded;

  UpdateWalletResponseModel({
    required this.data,
    required this.message,
    required this.succeeded,
  });

  factory UpdateWalletResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateWalletResponseModel(
      data: UpdateWalletData.fromJson(json['data']),
      message: json['message'] as String? ?? '',
      succeeded: json['succeeded'] as bool? ?? false,
    );
  }
}

class UpdateWalletData {
  final int id;
  final int customerId;
  final double currentBalance;

  UpdateWalletData({
    required this.id,
    required this.customerId,
    required this.currentBalance,
  });

  factory UpdateWalletData.fromJson(Map<String, dynamic> json) {
    // Handle potential null/int to double conversion for currentBalance
    final balance = json['currentBalance'];
    double currentBalance = 0.0;
    if (balance is int) {
      currentBalance = balance.toDouble();
    } else if (balance is double) {
      currentBalance = balance;
    }

    return UpdateWalletData(
      id: json['id'] as int? ?? 0,
      customerId: json['customerId'] as int? ?? 0,
      currentBalance: currentBalance,
    );
  }
}