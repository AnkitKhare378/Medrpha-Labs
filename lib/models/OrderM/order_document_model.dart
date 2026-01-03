class OrderDocumentModel {
  final int id;
  final String orderReportNo;
  final int orderId;
  final String reportPath;

  OrderDocumentModel({
    required this.id,
    required this.orderReportNo,
    required this.orderId,
    required this.reportPath,
  });

  factory OrderDocumentModel.fromJson(Map<String, dynamic> json) {
    return OrderDocumentModel(
      id: json['id'] ?? 0,
      orderReportNo: json['orderReportNo'] ?? '',
      orderId: json['orderId'] ?? 0,
      reportPath: json['reportPath'] ?? '',
    );
  }
}

class OrderDocumentResponse {
  final OrderDocumentModel? data;
  final bool succeeded;
  final String? message;

  OrderDocumentResponse({this.data, required this.succeeded, this.message});

  factory OrderDocumentResponse.fromJson(Map<String, dynamic> json) {
    return OrderDocumentResponse(
      succeeded: json['succeeded'] ?? false,
      message: json['message'],
      data: json['data'] != null ? OrderDocumentModel.fromJson(json['data']) : null,
    );
  }
}