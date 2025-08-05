class SalesinsightBrandDistributionModel {
  final String? status;
  final String? message;
  final List<BrandDistribution>? payload;
  final int? statusCode;

  SalesinsightBrandDistributionModel({
    this.status,
    this.message,
    this.payload,
    this.statusCode,
  });

  factory SalesinsightBrandDistributionModel.fromJson(Map<String, dynamic> json) {
    return SalesinsightBrandDistributionModel(
      status: json['status'],
      message: json['message'],
      payload: (json['payload'] as List<dynamic>?)
          ?.map((e) => BrandDistribution.fromJson(e))
          .toList(),
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload?.map((e) => e.toJson()).toList(),
      'statusCode': statusCode,
    };
  }
}

class BrandDistribution {
  final int? totalQuantity;
  final String? month;
  final String? percentage;
  final String? brand;

  BrandDistribution({
    this.totalQuantity,
    this.month,
    this.percentage,
    this.brand,
  });

  factory BrandDistribution.fromJson(Map<String, dynamic> json) {
    return BrandDistribution(
      totalQuantity: json['totalQuantity'],
      month: json['month'],
      percentage: json['percentage'],
      brand: json['brand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuantity': totalQuantity,
      'month': month,
      'percentage': percentage,
      'brand': brand,
    };
  }
}





/// Model for Sales Insight Top Selling Models


class SalesinsightTopSellingModelsModel {
  final String status;
  final String message;
  final int statusCode;
  final List<TopSellingModel> payload;

  SalesinsightTopSellingModelsModel({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.payload,
  });

  factory SalesinsightTopSellingModelsModel.fromJson(Map<String, dynamic> json) {
    return SalesinsightTopSellingModelsModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      payload: (json['payload'] as List<dynamic>?)
              ?.map((e) => TopSellingModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'statusCode': statusCode,
      'payload': payload.map((e) => e.toJson()).toList(),
    };
  }
}

class TopSellingModel {
  final double totalAmount;
  final int quantity;
  final String model;
  final String brand;

  TopSellingModel({
    required this.totalAmount,
    required this.quantity,
    required this.model,
    required this.brand,
  });

  factory TopSellingModel.fromJson(Map<String, dynamic> json) {
    return TopSellingModel(
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'quantity': quantity,
      'model': model,
      'brand': brand,
    };
  }
}

