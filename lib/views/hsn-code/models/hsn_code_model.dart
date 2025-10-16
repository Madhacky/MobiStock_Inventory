class HsnCodeModel {
  final int? id;
  final String hsnCode;
  final String itemCategory;
  final String? shopId;
  final double gstPercentage;
  final String? description;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  HsnCodeModel({
    this.id,
    required this.hsnCode,
    required this.itemCategory,
    this.shopId,
    required this.gstPercentage,
    this.description,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory HsnCodeModel.fromJson(Map<String, dynamic> json) {
    return HsnCodeModel(
      id: json['id'],
      hsnCode: json['hsnCode'] ?? '',
      itemCategory: json['itemCategory'] ?? '',
      shopId: json['shopId'],
      gstPercentage: (json['gstPercentage'] ?? 0.0).toDouble(),
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hsnCode': hsnCode,
      'itemCategory': itemCategory,
      'shopId': shopId,
      'gstPercentage': gstPercentage,
      'description': description,
      'isActive': isActive,
    };
  }
}

