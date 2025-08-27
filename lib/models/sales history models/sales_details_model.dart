// models/sales_detail_models.dart

class SaleDetailResponse {
  final int saleId;
  final String shopId;
  final String shopName;
  final String invoiceNumber;
  final String saleDate;
  final double totalPayableAmount;
  final String customerName;
  final List<SaleItem> items;
  final SaleDues? dues;
  final SaleEmi? emi;

  SaleDetailResponse({
    required this.saleId,
    required this.shopId,
    required this.shopName,
    required this.invoiceNumber,
    required this.saleDate,
    required this.totalPayableAmount,
    required this.customerName,
    required this.items,
    this.dues,
    this.emi,
  });

  factory SaleDetailResponse.fromJson(Map<String, dynamic> json) {
    return SaleDetailResponse(
      saleId: json['saleId'] ?? 0,
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      saleDate: json['saleDate'] ?? '',
      totalPayableAmount: (json['totalPayableAmount'] ?? 0.0).toDouble(),
      customerName: json['customerName'] ?? '',
      items: (json['items'] as List?)
          ?.map((item) => SaleItem.fromJson(item))
          .toList() ?? [],
      dues: json['dues'] != null ? SaleDues.fromJson(json['dues']) : null,
      emi: json['emi'] != null ? SaleEmi.fromJson(json['emi']) : null,
    );
  }

  String get formattedAmount => '₹${totalPayableAmount.toStringAsFixed(2)}';
  
  String get formattedDate {
    try {
      final DateTime parsedDate = DateTime.parse(saleDate);
      return '${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}';
    } catch (e) {
      return saleDate;
    }
  }

  String get formattedTime {
    try {
      final DateTime parsedDate = DateTime.parse(saleDate);
      return '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}

class SaleItem {
  final String model;
  final String color;
  final String ram;
  final String rom;
  final int quantity;
  final double? sellingPrice;
  final String accessoryName;
  final bool accessoryIncluded;

  SaleItem({
    required this.model,
    required this.color,
    required this.ram,
    required this.rom,
    required this.quantity,
    this.sellingPrice,
    required this.accessoryName,
    required this.accessoryIncluded,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      ram: json['ram'] ?? '',
      rom: json['rom'] ?? '',
      quantity: json['quantity'] ?? 1,
      sellingPrice: json['sellingPrice']?.toDouble(),
      accessoryName: json['accessoryName'] ?? '',
      accessoryIncluded: json['accessoryIncluded'] ?? false,
    );
  }

  String get formattedPrice => sellingPrice != null ? '₹${sellingPrice!.toStringAsFixed(2)}' : 'N/A';
  String get specifications => '$ram + $rom';
}

class SaleDues {
  final int id;
  final String shopId;
  final double totalDue;
  final double totalPaid;
  final double remainingDue;
  final List<PartialPayment> partialPayments;
  final String creationDate;
  final String paymentRetriableDate;
  final bool paid;

  SaleDues({
    required this.id,
    required this.shopId,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.partialPayments,
    required this.creationDate,
    required this.paymentRetriableDate,
    required this.paid,
  });

  factory SaleDues.fromJson(Map<String, dynamic> json) {
    return SaleDues(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? '',
      totalDue: (json['totalDue'] ?? 0.0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0.0).toDouble(),
      remainingDue: (json['remainingDue'] ?? 0.0).toDouble(),
      partialPayments: (json['partialPayments'] as List? ?? [])
          .map((payment) => PartialPayment.fromJson(payment))
          .toList(),
      creationDate: json['creationDate'] ?? '',
      paymentRetriableDate: json['paymentRetriableDate'] ?? '',
      paid: json['paid'] ?? false,
    );
  }
  String get formattedTotalDue => '₹${totalDue.toStringAsFixed(2)}';
  String get formattedTotalPaid => '₹${totalPaid.toStringAsFixed(2)}';
  String get formattedRemainingDue => '₹${remainingDue.toStringAsFixed(2)}';
  
  double get paymentProgress => totalDue > 0 ? (totalPaid / totalDue) : 0.0;
}

class PartialPayment {
  final int id;
  final double paidAmount;
  final List<int> paidDate;

  PartialPayment({
    required this.id,
    required this.paidAmount,
    required this.paidDate,
  });

  factory PartialPayment.fromJson(Map<String, dynamic> json) {
    return PartialPayment(
      id: json['id'] ?? 0,
      paidAmount: (json['paidAmount'] ?? 0.0).toDouble(),
      paidDate: List<int>.from(json['paidDate'] ?? []),
    );
  }

  String get formattedAmount => '₹${paidAmount.toStringAsFixed(2)}';
  
  String get formattedDate {
    if (paidDate.length >= 3) {
      return '${paidDate[2].toString().padLeft(2, '0')}-${paidDate[1].toString().padLeft(2, '0')}-${paidDate[0]}';
    }
    return 'N/A';
  }
}

class SaleEmi {
  // Add EMI fields based on your actual EMI structure
  final int? id;
  final double? monthlyAmount;
  final int? tenure;
  final double? totalAmount;

  SaleEmi({
    this.id,
    this.monthlyAmount,
    this.tenure,
    this.totalAmount,
  });

  factory SaleEmi.fromJson(Map<String, dynamic> json) {
    return SaleEmi(
      id: json['id'],
      monthlyAmount: json['monthlyAmount']?.toDouble(),
      tenure: json['tenure'],
      totalAmount: json['totalAmount']?.toDouble(),
    );
  }

  String get formattedMonthlyAmount => monthlyAmount != null ? '₹${monthlyAmount!.toStringAsFixed(2)}' : 'N/A';
  String get formattedTotalAmount => totalAmount != null ? '₹${totalAmount!.toStringAsFixed(2)}' : 'N/A';
}