class StockItem {
  final int id;
  final String shopId;
  final String model;
  final String ram;
  final String rom;
  final String color;
  final double sellingPrice;
  final int qty;
  final String company;
  final String logo;
  final List<int> createdDate;
  final int? lowStockQty;

  StockItem({
    required this.id,
    required this.shopId,
    required this.model,
    required this.ram,
    required this.rom,
    required this.color,
    required this.sellingPrice,
    required this.qty,
    required this.company,
    required this.logo,
    required this.createdDate,
    this.lowStockQty,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? '',
      model: json['model'] ?? '',
      ram: json['ram']?.toString() ?? '',
      rom: json['rom']?.toString() ?? '',
      color: json['color'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0.0).toDouble(),
      qty: json['qty'] ?? 0,
      company: json['company'] ?? '',
      logo: json['logo'] ?? '',
      createdDate: List<int>.from(json['createdDate'] ?? []),
      lowStockQty: json['lowStockQty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shopId': shopId,
      'model': model,
      'ram': ram,
      'rom': rom,
      'color': color,
      'sellingPrice': sellingPrice,
      'qty': qty,
      'company': company,
      'logo': logo,
      'createdDate': createdDate,
      'lowStockQty': lowStockQty,
    };
  }

  // Helper getters
  String get ramRomDisplay => '${ram}GB/${rom}GB';
  
  bool get isLowStock => qty <= 10;
  
  bool get isOutOfStock => qty == 0;
  
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  String get formattedPrice => '₹${sellingPrice.toStringAsFixed(0)}';
  
  DateTime get dateCreated {
    if (createdDate.length >= 3) {
      return DateTime(
        createdDate[0], // year
        createdDate[1], // month
        createdDate[2], // day
        createdDate.length > 3 ? createdDate[3] : 0, // hour
        createdDate.length > 4 ? createdDate[4] : 0, // minute
      );
    }
    return DateTime.now();
  }
}