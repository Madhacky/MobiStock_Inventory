// models/business_summary_model.dart
class BusinessSummaryModel {
  final int totalCompanies;
  final int totalModelsAvailable;
  final int totalStockAvailable;
  final int totalSoldUnits;
  final String topSellingBrand;
  final double totalRevenue;

  BusinessSummaryModel({
    required this.totalCompanies,
    required this.totalModelsAvailable,
    required this.totalStockAvailable,
    required this.totalSoldUnits,
    required this.topSellingBrand,
    required this.totalRevenue,
  });
}