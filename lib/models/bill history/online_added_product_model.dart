// models/online_products/product_model.dart

class ProductResponse {
  final String status;
  final String message;
  final ProductPayload payload;
  final int statusCode;

  ProductResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: ProductPayload.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class ProductPayload {
  final List<Product> content;
  final bool last;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final bool first;
  final int numberOfElements;
  final bool empty;

  ProductPayload({
    required this.content,
    required this.last,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory ProductPayload.fromJson(Map<String, dynamic> json) {
    return ProductPayload(
      content: (json['content'] as List?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
      last: json['last'] ?? true,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
      first: json['first'] ?? true,
      numberOfElements: json['numberOfElements'] ?? 0,
      empty: json['empty'] ?? true,
    );
  }
}

class Product {
  final int id;
  final String itemCategory;
  final String shopId;
  final String model;
  final double sellingPrice;
  final String ram;
  final String rom;
  final String color;
  final String? imei;
  final int qty;
  final String company;
  final String logo;
  final String createdDate;
  final String? description;
  final String purchasedFrom;
  final String? purchaseContact;
  final String purchaseDate;
  final String purchaseNotes;

  Product({
    required this.id,
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
    this.description,
    required this.purchasedFrom,
    this.purchaseContact,
    required this.purchaseDate,
    required this.purchaseNotes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      itemCategory: json['itemCategory'] ?? '',
      shopId: json['shopId'] ?? '',
      model: json['model'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      ram: json['ram'] ?? '',
      rom: json['rom'] ?? '',
      color: json['color'] ?? '',
      imei: json['imei'],
      qty: json['qty'] ?? 0,
      company: json['company'] ?? '',
      logo: json['logo'] ?? '',
      createdDate: json['createdDate'] ?? '',
      description: json['description'],
      purchasedFrom: json['purchasedFrom'] ?? '',
      purchaseContact: json['purchaseContact'],
      purchaseDate: json['purchaseDate'] ?? '',
      purchaseNotes: json['purchaseNotes'] ?? '',
    );
  }

  String get formattedPrice => '₹${sellingPrice.toStringAsFixed(0)}';
  
  String get ramRomDisplay => ram.isNotEmpty && rom.isNotEmpty 
      ? '$ram / $rom' 
      : ram.isNotEmpty 
          ? ram 
          : rom;
  
  String get categoryDisplayName => itemCategory.replaceAll('_', ' ');
  
  String get formattedDate {
    try {
      final date = DateTime.parse(createdDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return createdDate;
    }
  }
}

// Filter Response Model
class ProductFilterResponse {
  final String status;
  final String message;
  final ProductFilters payload;
  final int statusCode;

  ProductFilterResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory ProductFilterResponse.fromJson(Map<String, dynamic> json) {
    return ProductFilterResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: ProductFilters.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class ProductFilters {
  final List<String> companies;
  final List<String> models;
  final List<String> rams;
  final List<String> roms;
  final List<String> colors;
  final List<String> itemCategories;

  ProductFilters({
    required this.companies,
    required this.models,
    required this.rams,
    required this.roms,
    required this.colors,
    required this.itemCategories,
  });

  factory ProductFilters.fromJson(Map<String, dynamic> json) {
    return ProductFilters(
      companies: (json['companies'] as List?)?.cast<String>() ?? [],
      models: (json['models'] as List?)?.cast<String>() ?? [],
      rams: (json['rams'] as List?)?.cast<String>() ?? [],
      roms: (json['roms'] as List?)?.cast<String>() ?? [],
      colors: (json['colors'] as List?)?.cast<String>() ?? [],
      itemCategories: (json['itemCategories'] as List?)?.cast<String>() ?? [],
    );
  }
}