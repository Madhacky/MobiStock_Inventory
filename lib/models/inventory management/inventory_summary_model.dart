class SummaryCardsModel {
  final String status;
  final String message;
  final Payload payload;
  final int statusCode;

  SummaryCardsModel({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory SummaryCardsModel.fromJson(Map<String, dynamic> json) {
    return SummaryCardsModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: Payload.fromJson(json['payload']),
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "payload": payload.toJson(),
      "statusCode": statusCode,
    };
  }
}

class Payload {
  final int totalStock;
  final int lowStockCount;
  final int thisMonthPhonesSold;
  final int totalCompanies;

  Payload({
    required this.totalStock,
    required this.lowStockCount,
    required this.thisMonthPhonesSold,
    required this.totalCompanies,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      totalStock: json['totalStock'] ?? 0,
      lowStockCount: json['lowStockCount'] ?? 0,
      thisMonthPhonesSold: json['ThisMonthPhonesSold'] ?? 0,
      totalCompanies: json['totalCompanies'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalStock": totalStock,
      "lowStockCount": lowStockCount,
      "ThisMonthPhonesSold": thisMonthPhonesSold,
      "totalCompanies": totalCompanies,
    };
  }
}
