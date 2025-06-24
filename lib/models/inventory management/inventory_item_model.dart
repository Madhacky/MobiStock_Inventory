class InventoryItem {
  final int id;
  final String logo;
  final String model;
  final String ram;
  final String rom;
  final String color;
  final double sellingPrice;
  final int quantity;
  final String company;

  // Optional fields
  final String? shopId;
  final DateTime? createdDate;

  InventoryItem({
    required this.id,
    required this.logo,
    required this.model,
    required this.ram,
    required this.rom,
    required this.color,
    required this.sellingPrice,
    required this.quantity,
    required this.company,
    this.shopId,
    this.createdDate,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      logo: json['logo'] ?? '',
      model: json['model'] ?? '',
      ram: "${json['ram'] ?? ''}",
      rom: "${json['rom'] ?? ''}",
      color: json['color'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      quantity: json['qty'] ?? 0,
      company: json['company'] ?? '',
      shopId: json['shopId'],
      createdDate:
          (() {
            final date = json['createdDate'];
            if (date is List &&
                date.length >= 5 &&
                date.every(
                  (e) => e is int || int.tryParse(e.toString()) != null,
                )) {
              final year = int.parse(date[0].toString());
              final month = int.parse(date[1].toString());
              final day = int.parse(date[2].toString());
              final hour = int.parse(date[3].toString());
              final minute = int.parse(date[4].toString());
              return DateTime(year, month, day, hour, minute);
            }
            return null;
          })(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo': logo,
      'model': model,
      'ram': ram,
      'rom': rom,
      'color': color,
      'sellingPrice': sellingPrice,
      'qty': quantity,
      'company': company,
      if (shopId != null) 'shopId': shopId,
      if (createdDate != null)
        'createdDate': [
          createdDate!.year,
          createdDate!.month,
          createdDate!.day,
          createdDate!.hour,
          createdDate!.minute,
        ],
    };
  }
}
