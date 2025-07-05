
// Customer Dues Response Model
class CustomerDuesResponse {
  final String status;
  final String message;
  final List<CustomerDue> payload;
  final int statusCode;

  CustomerDuesResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory CustomerDuesResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDuesResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: (json['payload'] as List<dynamic>?)
          ?.map((item) => CustomerDue.fromJson(item))
          .toList() ?? [],
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

// Customer Due Model
class CustomerDue {
  final int id;
  final String shopId;
  final String name;
  final double totalDue;
  final double totalPaid;
  final double remainingDue;
  final String creationDate;
  final int customerId;
  final int saleId;
  final List<PartialPayment> partialPayments;

  CustomerDue({
    required this.id,
    required this.shopId,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.creationDate,
    required this.customerId,
    required this.saleId,
    required this.partialPayments,
    required this.name,

  });

  factory CustomerDue.fromJson(Map<String, dynamic> json) {
    return CustomerDue(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? '',
      name: json['name'],
      totalDue: (json['totalDue'] ?? 0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0).toDouble(),
      remainingDue: (json['remainingDue'] ?? 0).toDouble(),
      creationDate: json['creationDate'] ?? '',
      customerId: json['customerId'] ?? 0,
      saleId: json['saleId'] ?? 0,
      partialPayments: (json['partialPayments'] as List<dynamic>?)
          ?.map((item) => PartialPayment.fromJson(item))
          .toList() ?? [],
    );
  }

  // Helper methods
  double get paymentProgress => totalDue > 0 ? (totalPaid / totalDue) * 100 : 0;
  bool get isFullyPaid => remainingDue <= 0;
  bool get isOverpaid => remainingDue < 0;
  String get statusText => isOverpaid ? 'Overpaid' : isFullyPaid ? 'Paid' : 'Partial';
  String get customerName => name; // This should come from customer data
}

// Partial Payment Model
class PartialPayment {
  final int id;
  final double paidAmount;
  final String paidDate;

  PartialPayment({
    required this.id,
    required this.paidAmount,
    required this.paidDate,
  });

  factory PartialPayment.fromJson(Map<String, dynamic> json) {
    return PartialPayment(
      id: json['id'] ?? 0,
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      paidDate: json['paidDate'] ?? '',
    );
  }
}

// Summary Model for Dashboard Cards
class DuesSummaryModel {
  final double totalGiven;
  final double totalCollected;
  final double totalRemaining;
  final double thisMonthCollection;
  final int totalCustomers;

  DuesSummaryModel({
    required this.totalGiven,
    required this.totalCollected,
    required this.totalRemaining,
    required this.thisMonthCollection,
    required this.totalCustomers,
  });

  factory DuesSummaryModel.fromDuesList(List<CustomerDue> dues) {
    double totalGiven = 0;
    double totalCollected = 0;
    double totalRemaining = 0;
    double thisMonthCollection = 0;
    
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    for (var due in dues) {
      totalGiven += due.totalDue;
      totalCollected += due.totalPaid;
      totalRemaining += due.remainingDue > 0 ? due.remainingDue : 0;

      // Calculate this month's collection
      for (var payment in due.partialPayments) {
        final paymentDate = DateTime.tryParse(payment.paidDate);
        if (paymentDate != null && 
            paymentDate.month == currentMonth && 
            paymentDate.year == currentYear) {
          thisMonthCollection += payment.paidAmount;
        }
      }
    }

    return DuesSummaryModel(
      totalGiven: totalGiven,
      totalCollected: totalCollected,
      totalRemaining: totalRemaining,
      thisMonthCollection: thisMonthCollection,
      totalCustomers: dues.length,
    );
  }
}