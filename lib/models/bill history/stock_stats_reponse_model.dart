class StockStats {
  final int lastMonthStock;
  final int todayStock;
  final int totalStocks;
  final int thisMonthStock;
  final double growthPercentage;
  final List<StockItemModel> thisMonthItems;
  final List<StockItemModel> todayItems;

  StockStats({
    required this.lastMonthStock,
    required this.todayStock,
    required this.totalStocks,
    required this.thisMonthStock,
    required this.growthPercentage,
    required this.thisMonthItems,
    required this.todayItems,
  });

  factory StockStats.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] ?? {};

    return StockStats(
      lastMonthStock: payload['lastMonthStock'] ?? 0,
      todayStock: payload['todayStock'] ?? 0,
      totalStocks: payload['totalStocks'] ?? 0,
      thisMonthStock: payload['thisMonthStock'] ?? 0,
      growthPercentage: (payload['growthPercentage'] ?? 0.0).toDouble(),
      thisMonthItems: (payload['thisMonthItems'] as List<dynamic>?)
              ?.map((e) => StockItemModel.fromJson(e))
              .toList() ??
          [],
      todayItems: (payload['todayItems'] as List<dynamic>?)
              ?.map((e) => StockItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StockItemModel {
  final String itemCategory;
  final String shopId;
  final String model;
  final double sellingPrice;
  final int ram;
  final int rom;
  final String color;
  final int qty;
  final String company;
  final String logo;
  final List<int> createdDate;
  final String description;
  final int billMobileItem;

  StockItemModel({
    required this.itemCategory,
    required this.shopId,
    required this.model,
    required this.sellingPrice,
    required this.ram,
    required this.rom,
    required this.color,
    required this.qty,
    required this.company,
    required this.logo,
    required this.createdDate,
    required this.description,
    required this.billMobileItem,
  });

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      itemCategory: json['itemCategory'] ?? '',
      shopId: json['shopId'] ?? '',
      model: json['model'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      ram: json['ram'] ?? 0,
      rom: json['rom'] ?? 0,
      color: json['color'] ?? '',
      qty: json['qty'] ?? 0,
      company: json['company'] ?? '',
      logo: json['logo'] ?? '',
      createdDate: (json['createdDate'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      description: json['description'] ?? '',
      billMobileItem: json['billMobileItem'] ?? 0,
    );
  }
}
