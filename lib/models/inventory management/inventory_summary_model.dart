// Model for Summary Cards
class SummaryCardsModel {
  final int totalStock;
  final int lowStockCount;
  final int totalCompanies;
  final int totalPhonesSold;

  SummaryCardsModel({
    required this.totalStock,
    required this.lowStockCount,
    required this.totalCompanies,
    required this.totalPhonesSold,
  });

  factory SummaryCardsModel.fromJson(Map<String, dynamic> json) {
    return SummaryCardsModel(
      totalStock: json['totalStock'] ?? 0,
      lowStockCount: json['lowStockCount'] ?? 0,
      totalCompanies: json['totalCompanies'] ?? 0,
      totalPhonesSold: json['totalPhonesSold'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStock': totalStock,
      'lowStockCount': lowStockCount,
      'totalCompanies': totalCompanies,
      'totalPhonesSold': totalPhonesSold,
    };
  }

  @override
  String toString() {
    return 'SummaryCardsModel{totalStock: $totalStock, lowStockCount: $lowStockCount, totalCompanies: $totalCompanies, totalPhonesSold: $totalPhonesSold}';
  }
}

// API Response Model
class SummaryCardsResponse {
  final String status;
  final String message;
  final SummaryCardsModel payload;
  final int statusCode;

  SummaryCardsResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory SummaryCardsResponse.fromJson(Map<String, dynamic> json) {
    return SummaryCardsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: SummaryCardsModel.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}