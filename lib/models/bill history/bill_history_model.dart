class BillItem {
  final String shopId;
  final String model;
  final double sellingPrice;
  final int ram;
  final int rom;
  final String color;
  final int qty;
  final String company;
  final String logo;
  final int billMobileItem;

  BillItem({
    required this.shopId,
    required this.model,
    required this.sellingPrice,
    required this.ram,
    required this.rom,
    required this.color,
    required this.qty,
    required this.company,
    required this.logo,
    required this.billMobileItem,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      shopId: json['shopId'] ?? '',
      model: json['model'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      ram: json['ram'] ?? 0,
      rom: json['rom'] ?? 0,
      color: json['color'] ?? '',
      qty: json['qty'] ?? 0,
      company: json['company'] ?? '',
      logo: json['logo'] ?? '',
      billMobileItem: json['billMobileItem'] ?? 0,
    );
  }

  String get ramRomDisplay => '${ram}GB/${rom}GB';
  String get formattedPrice => '₹${sellingPrice.toStringAsFixed(0)}';
}

class Bill {
  final int billId;
  final String shopId;
  final List<int> date;
  final String companyName;
  final double amount;
  final double withoutGst;
  final double gst;
  final double dues;
  final List<BillItem> items;
  final bool paid;
  final String? invoice;

  Bill({
    required this.billId,
    required this.shopId,
    required this.date,
    required this.companyName,
    required this.amount,
    required this.withoutGst,
    required this.gst,
    required this.dues,
    required this.items,
    required this.paid,
    this.invoice,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      billId: json['billId'] ?? 0,
      shopId: json['shopId'] ?? '',
      date: List<int>.from(json['date'] ?? []),
      companyName: json['companyName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      withoutGst: (json['withoutGst'] ?? 0).toDouble(),
      gst: (json['gst'] ?? 0).toDouble(),
      dues: (json['dues'] ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => BillItem.fromJson(item))
              .toList() ??
          [],
      paid: json['paid'] ?? false,
      invoice: json['invoice'],
    );
  }

  String get formattedDate {
    if (date.length >= 3) {
      return '${date[2].toString().padLeft(2, '0')}/${date[1].toString().padLeft(2, '0')}/${date[0]}';
    }
    return '';
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(0)}';
  String get formattedDues => '₹${dues.toStringAsFixed(0)}';
  String get formattedGst => '₹${gst.toStringAsFixed(0)}';
  
  String get status => paid ? 'Paid' : 'Pending';
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.qty);
}

class BillsResponse {
  final List<Bill> content;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;

  BillsResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
  });

  factory BillsResponse.fromJson(Map<String, dynamic> json) {
    return BillsResponse(
      content: (json['content'] as List<dynamic>?)
              ?.map((bill) => Bill.fromJson(bill))
              .toList() ??
          [],
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      last: json['last'] ?? false,
      first: json['first'] ?? false,
    );
  }
}