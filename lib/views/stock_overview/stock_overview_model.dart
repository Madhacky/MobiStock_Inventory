class StockOverviewModel {
  final String status;
  final String message;
  final Payload payload;
  final int statusCode;

  StockOverviewModel({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory StockOverviewModel.fromJson(Map<String, dynamic> json) {
    return StockOverviewModel(
      status: json['status'],
      message: json['message'],
      payload: Payload.fromJson(json['payload']),
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'payload': payload.toJson(),
        'statusCode': statusCode,
      };
}

class Payload {
  final Map<String, int> companyWiseStock;
  final int totalStock;
  final List<LowStockDetail> lowStockDetails;

  Payload({
    required this.companyWiseStock,
    required this.totalStock,
    required this.lowStockDetails,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      companyWiseStock:
          Map<String, int>.from(json['companyWiseStock'] ?? {}),
      totalStock: json['totalStock'],
      lowStockDetails: (json['lowStockDetails'] as List)
          .map((e) => LowStockDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'companyWiseStock': companyWiseStock,
        'totalStock': totalStock,
        'lowStockDetails': lowStockDetails.map((e) => e.toJson()).toList(),
      };
}

class LowStockDetail {
  final int qty;
  final String model;
  final String company;

  LowStockDetail({
    required this.qty,
    required this.model,
    required this.company,
  });

  factory LowStockDetail.fromJson(Map<String, dynamic> json) {
    return LowStockDetail(
      qty: json['qty'],
      model: json['model'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() => {
        'qty': qty,
        'model': model,
        'company': company,
      };
}
