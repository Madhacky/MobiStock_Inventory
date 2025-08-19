// stock_item_model.dart
import 'package:intl/intl.dart';

class StockItemsResponse {
  final int totalItems;
  final int totalQtyAdded;
  final int totalPages;
  final int currentPage;
  final List<StockItem> items;
  final int totalDistinctCompanies;
  final bool last;

  StockItemsResponse({
    required this.totalItems,
    required this.totalQtyAdded,
    required this.totalPages,
    required this.currentPage,
    required this.items,
    required this.totalDistinctCompanies,
    required this.last,
  });

  factory StockItemsResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] ?? {};
    return StockItemsResponse(
      totalItems: payload['totalItems'] ?? 0,
      totalQtyAdded: payload['totalQtyAdded'] ?? 0,
      totalPages: payload['totalPages'] ?? 0,
      currentPage: payload['currentPage'] ?? 0,
      items: (payload['items'] as List<dynamic>?)
          ?.map((item) => StockItem.fromJson(item))
          .toList() ?? [],
      totalDistinctCompanies: payload['totalDistinctCompanies'] ?? 0,
      last: (payload['currentPage'] ?? 0) >= ((payload['totalPages'] ?? 1) - 1),
    );
  }
}

class StockItem {
  final String itemCategory;
  final String shopId;
  final String model;
  final double sellingPrice;
  final int ram;
  final int rom;
  final String color;
  final String? imei;
  final int qty;
  final String company;
  final String logo;
  final DateTime createdDate;
  final String description;
  final int billMobileItem;

  StockItem({
    required this.itemCategory,
    required this.shopId,
    required this.model,
    required this.sellingPrice,
    required this.ram,
    required this.rom,
    required this.color,
    this.imei,
    required this.qty,
    required this.company,
    required this.logo,
    required this.createdDate,
    required this.description,
    required this.billMobileItem,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      itemCategory: json['itemCategory'] ?? '',
      shopId: json['shopId'] ?? '',
      model: json['model'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      ram: json['ram'] ?? 0,
      rom: json['rom'] ?? 0,
      color: json['color'] ?? '',
      imei: json['imei'],
      qty: json['qty'] ?? 0,
      company: json['company'] ?? '',
      logo: json['logo'] ?? '',
      createdDate: _parseDate(json['createdDate']),
      description: json['description'] ?? '',
      billMobileItem: json['billMobileItem'] ?? 0,
    );
  }

  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(createdDate);
  }

  String get formattedPrice {
    final formatter = NumberFormat('#,##,###');
    return '₹${formatter.format(sellingPrice)}';
  }

  String get ramRomDisplay {
    if (itemCategory.toLowerCase().contains('smartphone') || 
        itemCategory.toLowerCase().contains('tablet') ||
        itemCategory.toLowerCase().contains('phone')) {
      return '${ram}GB/${rom}GB';
    }
    return '';
  }

  String get categoryDisplayName {
    return itemCategory
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

// Helper function to parse date from various formats
DateTime _parseDate(dynamic dateValue) {
  if (dateValue == null) {
    return DateTime.now();
  }
  
  if (dateValue is String) {
    try {
      // Handle "YYYY-MM-DD" format
      return DateTime.parse(dateValue);
    } catch (e) {
      return DateTime.now();
    }
  }
  
  if (dateValue is List<dynamic>) {
    // Handle the old integer array format for backward compatibility
    try {
      if (dateValue.length >= 3) {
        int year = dateValue[0] as int;
        int month = dateValue[1] as int;
        int day = dateValue[2] as int;
        return DateTime(year, month, day);
      }
    } catch (e) {
      return DateTime.now();
    }
  }
  
  return DateTime.now();
}