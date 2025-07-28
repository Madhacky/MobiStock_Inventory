// models/customer_due_details_model.dart
class CustomerDueDetailsModel {
  final int duesId;
  final double totalDue;
  final double totalPaid;
  final double remainingDue;
  final List<int> creationDate;
  final List<int> paymentRetriableDate;
  final String? approvedBy;
  final Customer customer;
  final List<PartialPaymentDetail> partialPayments;
  final bool paid;

  CustomerDueDetailsModel({
    required this.duesId,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.creationDate,
    required this.paymentRetriableDate,
    this.approvedBy,
    required this.customer,
    required this.partialPayments,
    required this.paid,
  });

  factory CustomerDueDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDueDetailsModel(
      duesId: json['duesId'] ?? 0,
      totalDue: (json['totalDue'] ?? 0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0).toDouble(),
      remainingDue: (json['remainingDue'] ?? 0).toDouble(),
      creationDate: List<int>.from(json['creationDate'] ?? []),
      paymentRetriableDate: List<int>.from(json['paymentRetriableDate'] ?? []),
      approvedBy: json['approvedBy'],
      customer: Customer.fromJson(json['customer'] ?? {}),
      partialPayments: (json['partialPayments'] as List<dynamic>?)
          ?.map((item) => PartialPaymentDetail.fromJson(item))
          .toList() ?? [],
      paid: json['paid'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duesId': duesId,
      'totalDue': totalDue,
      'totalPaid': totalPaid,
      'remainingDue': remainingDue,
      'creationDate': creationDate,
      'paymentRetriableDate': paymentRetriableDate,
      'approvedBy': approvedBy,
      'customer': customer.toJson(),
      'partialPayments': partialPayments.map((item) => item.toJson()).toList(),
      'paid': paid,
    };
  }

  // Helper methods
  DateTime get creationDateTime {
    if (creationDate.length >= 3) {
      return DateTime(creationDate[0], creationDate[1], creationDate[2]);
    }
    return DateTime.now();
  }

  DateTime get paymentRetriableDatetime {
    if (paymentRetriableDate.length >= 3) {
      return DateTime(paymentRetriableDate[0], paymentRetriableDate[1], paymentRetriableDate[2]);
    }
    return DateTime.now();
  }

  double get paymentProgress {
    if (totalDue <= 0) return 0.0;
    return (totalPaid / totalDue) * 100;
  }

  bool get isFullyPaid => remainingDue <= 0;
  bool get isOverpaid => remainingDue < 0;
}

class Customer {
  final int id;
  final String name;
  final String email;
  final String primaryPhone;
  final String primaryAddress;
  final String location;
  final List<String> alternatePhones;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.primaryPhone,
    required this.primaryAddress,
    required this.location,
    required this.alternatePhones,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      primaryPhone: json['primaryPhone'] ?? '',
      primaryAddress: json['primaryAddress'] ?? '',
      location: json['location'] ?? '',
      alternatePhones: List<String>.from(json['alternatePhones'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'primaryPhone': primaryPhone,
      'primaryAddress': primaryAddress,
      'location': location,
      'alternatePhones': alternatePhones,
    };
  }
}

class PartialPaymentDetail {
  final int id;
  final double paidAmount;
  final List<int> paidDate;

  PartialPaymentDetail({
    required this.id,
    required this.paidAmount,
    required this.paidDate,
  });

  factory PartialPaymentDetail.fromJson(Map<String, dynamic> json) {
    return PartialPaymentDetail(
      id: json['id'] ?? 0,
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      paidDate: List<int>.from(json['paidDate'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paidAmount': paidAmount,
      'paidDate': paidDate,
    };
  }

  DateTime get paidDateTime {
    if (paidDate.length >= 3) {
      return DateTime(paidDate[0], paidDate[1], paidDate[2]);
    }
    return DateTime.now();
  }
}