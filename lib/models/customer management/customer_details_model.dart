
class CustomerDetailsResponse {
  final String status;
  final String message;
  final CustomerDetailsPayload payload;
  final int statusCode;

  CustomerDetailsResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: CustomerDetailsPayload.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class CustomerDetailsPayload {
  final CustomerDetail customer;
  final double totalPurchases;
  final double totalDues;
  final int purchaseCount;
  final List<DueDetail> duesList;

  CustomerDetailsPayload({
    required this.customer,
    required this.totalPurchases,
    required this.totalDues,
    required this.purchaseCount,
    required this.duesList,
  });

  factory CustomerDetailsPayload.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsPayload(
      customer: CustomerDetail.fromJson(json['customer'] ?? {}),
      totalPurchases: (json['totalPurchases'] ?? 0.0).toDouble(),
      totalDues: (json['totalDues'] ?? 0.0).toDouble(),
      purchaseCount: json['purchaseCount'] ?? 0,
      duesList: (json['duesList'] as List<dynamic>?)
          ?.map((e) => DueDetail.fromJson(e))
          .toList() ?? [],
    );
  }
}

class CustomerDetail {
  final int id;
  final String name;
  final String primaryNumber;
  final List<String> phoneNumbers;
  final String defaultAddress;
  final String? profilePhoto;
  final List<CustomerAddress> addresses;
  final List<dynamic> documents;
  final List<Sale> sales;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.primaryNumber,
    required this.phoneNumbers,
    required this.defaultAddress,
    this.profilePhoto,
    required this.addresses,
    required this.documents,
    required this.sales,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      primaryNumber: json['primaryNumber'] ?? '',
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      defaultAddress: json['defaultAddress'] ?? '',
      profilePhoto: json['profilePhoto'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => CustomerAddress.fromJson(e))
          .toList() ?? [],
      documents: json['documents'] ?? [],
      sales: (json['sales'] as List<dynamic>?)
          ?.map((e) => Sale.fromJson(e))
          .toList() ?? [],
    );
  }
}

class CustomerAddress {
  final int id;
  final String label;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final bool isDefault;

  CustomerAddress({
    required this.id,
    required this.label,
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.isDefault,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['default'] ?? false,
    );
  }

  String get fullAddress {
    List<String> addressParts = [];
    if (addressLine1.isNotEmpty && addressLine1 != 'N/A') addressParts.add(addressLine1);
    if (addressLine2.isNotEmpty && addressLine2 != 'N/A') addressParts.add(addressLine2);
    if (landmark.isNotEmpty && landmark != 'N/A') addressParts.add(landmark);
    if (city.isNotEmpty) addressParts.add(city);
    if (state.isNotEmpty) addressParts.add(state);
    if (pincode.isNotEmpty && pincode != '000000') addressParts.add(pincode);
    
    return addressParts.join(', ');
  }
}

class Sale {
  final int id;
  final String paymentMode;
  final String paymentMethod;
  final String shopId;
  final String shopName;
  final String invoiceNumber;
  final List<int> saleDate;
  final List<SaleItem> items;
  final double gstPercentage;
  final double amountWithGst;
  final double amountWithoutGst;
  final double extraCharges;
  final double accessoriesCost;
  final double repairCharges;
  final double totalAmount;
  final double totalDiscount;
  final double totalPayableAmount;
  final double downPayment;
  final String? invoicePdf;
  final String? invoiceUrlPath;
  final dynamic emi;
  final dynamic due;
  final dynamic paymentRetriableDate;
  final List<int> createdAt;
  final bool paid;

  Sale({
    required this.id,
    required this.paymentMode,
    required this.paymentMethod,
    required this.shopId,
    required this.shopName,
    required this.invoiceNumber,
    required this.saleDate,
    required this.items,
    required this.gstPercentage,
    required this.amountWithGst,
    required this.amountWithoutGst,
    required this.extraCharges,
    required this.accessoriesCost,
    required this.repairCharges,
    required this.totalAmount,
    required this.totalDiscount,
    required this.totalPayableAmount,
    required this.downPayment,
    this.invoicePdf,
    this.invoiceUrlPath,
    this.emi,
    this.due,
    this.paymentRetriableDate,
    required this.createdAt,
    required this.paid,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? 0,
      paymentMode: json['paymentMode'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      shopId: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      saleDate: (json['saleDate'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => SaleItem.fromJson(e))
          .toList() ?? [],
      gstPercentage: (json['gstPercentage'] ?? 0.0).toDouble(),
      amountWithGst: (json['amountWithGst'] ?? 0.0).toDouble(),
      amountWithoutGst: (json['amountWithoutGst'] ?? 0.0).toDouble(),
      extraCharges: (json['extraCharges'] ?? 0.0).toDouble(),
      accessoriesCost: (json['accessoriesCost'] ?? 0.0).toDouble(),
      repairCharges: (json['repairCharges'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      totalDiscount: (json['totalDiscount'] ?? 0.0).toDouble(),
      totalPayableAmount: (json['totalPayableAmount'] ?? 0.0).toDouble(),
      downPayment: (json['downPayment'] ?? 0.0).toDouble(),
      invoicePdf: json['invoicePdf'],
      invoiceUrlPath: json['invoiceUrlPath'],
      emi: json['emi'],
      due: json['due'],
      paymentRetriableDate: json['paymentRetriableDate'],
      createdAt: (json['createdAt'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
      paid: json['paid'] ?? false,
    );
  }

  DateTime get saleDateAsDateTime {
    if (saleDate.length >= 3) {
      return DateTime(saleDate[0], saleDate[1], saleDate[2]);
    }
    return DateTime.now();
  }

  DateTime get createdAtAsDateTime {
    if (createdAt.length >= 5) {
      return DateTime(createdAt[0], createdAt[1], createdAt[2], createdAt[3], createdAt[4]);
    }
    return DateTime.now();
  }

  String get formattedSaleDate {
    final date = saleDateAsDateTime;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String get formattedCreatedAt {
    final date = createdAtAsDateTime;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}

class SaleItem {
  final int id;
  final String itemCategory;
  final String model;
  final String color;
  final String ram;
  final String rom;
  final String imei;
  final int quantity;
  final String company;
  final double sellingPrice;
  final bool accessoryIncluded;

  SaleItem({
    required this.id,
    required this.itemCategory,
    required this.model,
    required this.color,
    required this.ram,
    required this.rom,
    required this.imei,
    required this.quantity,
    required this.company,
    required this.sellingPrice,
    required this.accessoryIncluded,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: json['id'] ?? 0,
      itemCategory: json['itemCategory'] ?? '',
      model: json['model'] ?? '',
      color: json['color'] ?? '',
      ram: json['ram'] ?? '',
      rom: json['rom'] ?? '',
      imei: json['imei'] ?? '',
      quantity: json['quantity'] ?? 0,
      company: json['company'] ?? '',
      sellingPrice: (json['sellingPrice'] ?? 0.0).toDouble(),
      accessoryIncluded: json['accessoryIncluded'] ?? false,
    );
  }

  String get displayName => "$company $model";
  String get specifications => "$ram RAM, $rom Storage";
  String get formattedPrice => "₹${sellingPrice.toStringAsFixed(0)}";
}

class DueDetail {
  final int id;
  final dynamic customer;
  final String shopId;
  final double totalDue;
  final double totalPaid;
  final double remainingDue;
  final List<PartialPayment> partialPayments;
  final List<int> creationDate;
  final List<int> paymentRetriableDate;
  final dynamic approvedBy;
  final bool paid;

  DueDetail({
    required this.id,
    this.customer,
    required this.shopId,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.partialPayments,
    required this.creationDate,
    required this.paymentRetriableDate,
    this.approvedBy,
    required this.paid,
  });

  factory DueDetail.fromJson(Map<String, dynamic> json) {
    return DueDetail(
      id: json['id'] ?? 0,
      customer: json['customer'],
      shopId: json['shopId'] ?? '',
      totalDue: (json['totalDue'] ?? 0.0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0.0).toDouble(),
      remainingDue: (json['remainingDue'] ?? 0.0).toDouble(),
      partialPayments: (json['partialPayments'] as List<dynamic>?)
          ?.map((e) => PartialPayment.fromJson(e))
          .toList() ?? [],
      creationDate: (json['creationDate'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
      paymentRetriableDate: (json['paymentRetriableDate'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
      approvedBy: json['approvedBy'],
      paid: json['paid'] ?? false,
    );
  }

  DateTime get creationDateAsDateTime {
    if (creationDate.length >= 3) {
      return DateTime(creationDate[0], creationDate[1], creationDate[2]);
    }
    return DateTime.now();
  }

  DateTime get paymentRetriableDateAsDateTime {
    if (paymentRetriableDate.length >= 3) {
      return DateTime(paymentRetriableDate[0], paymentRetriableDate[1], paymentRetriableDate[2]);
    }
    return DateTime.now();
  }

  String get formattedCreationDate {
    final date = creationDateAsDateTime;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String get formattedPaymentRetriableDate {
    final date = paymentRetriableDateAsDateTime;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String get statusText => paid ? 'Paid' : 'Pending';
  
  String get formattedTotalDue => "₹${totalDue.toStringAsFixed(0)}";
  String get formattedTotalPaid => "₹${totalPaid.toStringAsFixed(0)}";
  String get formattedRemainingDue => "₹${remainingDue.toStringAsFixed(0)}";
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
      paidDate: (json['paidDate'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? [],
    );
  }

  DateTime get paidDateAsDateTime {
    if (paidDate.length >= 3) {
      return DateTime(paidDate[0], paidDate[1], paidDate[2]);
    }
    return DateTime.now();
  }

  String get formattedPaidDate {
    final date = paidDateAsDateTime;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String get formattedPaidAmount => "₹${paidAmount.toStringAsFixed(0)}";
}