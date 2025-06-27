// Model for Summary Cards
class SummaryCardsModel {
  final int totalCompanies;
  final int totalModelsAvailable;
  final int totalStockAvailable;
  final int totalUnitsSold;
  final String topSellingBrandAndModel;
  final double totalRevenue;

  SummaryCardsModel({
    required this.totalCompanies,
    required this.totalModelsAvailable,
    required this.totalStockAvailable,
    required this.totalUnitsSold,
    required this.topSellingBrandAndModel,
    required this.totalRevenue,
  });

  factory SummaryCardsModel.fromJson(Map<String, dynamic> json) {
    return SummaryCardsModel(
      totalCompanies: json['totalCompanies'] ?? 0,
      totalModelsAvailable: json['totalModelsAvailable'] ?? 0,
      totalStockAvailable: json['totalStockAvailable'] ?? 0,
      totalUnitsSold: json['totalUnitsSold'] ?? 0,
      topSellingBrandAndModel: json['topSellingBrandAndModel'] ?? '',
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCompanies': totalCompanies,
      'totalModelsAvailable': totalModelsAvailable,
      'totalStockAvailable': totalStockAvailable,
      'totalUnitsSold': totalUnitsSold,
      'topSellingBrandAndModel': topSellingBrandAndModel,
      'totalRevenue': totalRevenue,
    };
  }

  @override
  String toString() {
    return 'SummaryCardsModel{totalCompanies: $totalCompanies, totalModelsAvailable: $totalModelsAvailable, totalStockAvailable: $totalStockAvailable, totalUnitsSold: $totalUnitsSold, topSellingBrandAndModel: $topSellingBrandAndModel, totalRevenue: $totalRevenue}';
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