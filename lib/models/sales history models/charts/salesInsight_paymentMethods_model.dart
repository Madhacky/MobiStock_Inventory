class SalesinsightPaymentmethodsModel {
  String? status;
  String? message;
  Payload? payload;
  int? statusCode;

  SalesinsightPaymentmethodsModel({
    this.status,
    this.message,
    this.payload,
    this.statusCode,
  });

  factory SalesinsightPaymentmethodsModel.fromJson(Map<String, dynamic> json) {
    return SalesinsightPaymentmethodsModel(
      status: json['status'],
      message: json['message'],
      payload: json['payload'] != null
          ? Payload.fromJson(json['payload'])
          : null,
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload?.toJson(),
      'statusCode': statusCode,
    };
  }
}

class Payload {
  int? totalPayments;
  List<Distribution>? distributions;

  Payload({
    this.totalPayments,
    this.distributions,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      totalPayments: json['totalPayments'],
      distributions: json['distributions'] != null
          ? List<Distribution>.from(
              json['distributions'].map((e) => Distribution.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPayments': totalPayments,
      'distributions': distributions?.map((e) => e.toJson()).toList(),
    };
  }
}

class Distribution {
  String? paymentMethod;
  String? paymentType;
  int? count;
  double? totalAmount;
  double? percentage;

  Distribution({
    this.paymentMethod,
    this.paymentType,
    this.count,
    this.totalAmount,
    this.percentage,
  });

  factory Distribution.fromJson(Map<String, dynamic> json) {
    return Distribution(
      paymentMethod: json['paymentMethod'],
      paymentType: json['paymentType'],
      count: json['count'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      percentage: (json['percentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'paymentType': paymentType,
      'count': count,
      'totalAmount': totalAmount,
      'percentage': percentage,
    };
  }
}





class CompanyDropDownList {
  final List<String>? companies;
  final List<String>? models;
  final List<String>? rams;
  final List<String>? roms;
  final List<String>? colors;
  final List<String>? itemCategories;

  CompanyDropDownList({
    this.companies,
    this.models,
    this.rams,
    this.roms,
    this.colors,
    this.itemCategories,
  });

  factory CompanyDropDownList.fromJson(Map<String, dynamic> json) {
    return CompanyDropDownList(
      companies: List<String>.from(json['companies'] ?? []),
      models: List<String>.from(json['models'] ?? []),
      rams: List<String>.from(json['rams'] ?? []),
      roms: List<String>.from(json['roms'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      itemCategories: List<String>.from(json['itemCategories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companies': companies,
      'models': models,
      'rams': rams,
      'roms': roms,
      'colors': colors,
      'itemCategories': itemCategories,
    };
  }
}
