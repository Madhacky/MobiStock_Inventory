// Updated Customer Dues Response Model with Pagination
class CustomerDuesResponse {
  final String status;
  final String message;
  final PaginatedDuesPayload payload;
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
      payload: PaginatedDuesPayload.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

// Paginated Dues Payload
class PaginatedDuesPayload {
  final List<CustomerDue> content;
  final PageableInfo pageable;
  final bool last;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final bool first;
  final int numberOfElements;
  final bool empty;

  PaginatedDuesPayload({
    required this.content,
    required this.pageable,
    required this.last,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
    required this.first,
    required this.numberOfElements,
    required this.empty,
  });

  factory PaginatedDuesPayload.fromJson(Map<String, dynamic> json) {
    return PaginatedDuesPayload(
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => CustomerDue.fromJson(item))
          .toList() ?? [],
      pageable: PageableInfo.fromJson(json['pageable'] ?? {}),
      last: json['last'] ?? false,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: json['size'] ?? 0,
      number: json['number'] ?? 0,
      first: json['first'] ?? false,
      numberOfElements: json['numberOfElements'] ?? 0,
      empty: json['empty'] ?? false,
    );
  }
}

// Pageable Info
class PageableInfo {
  final int pageNumber;
  final int pageSize;
  final int offset;
  final bool paged;
  final bool unpaged;

  PageableInfo({
    required this.pageNumber,
    required this.pageSize,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory PageableInfo.fromJson(Map<String, dynamic> json) {
    return PageableInfo(
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
      offset: json['offset'] ?? 0,
      paged: json['paged'] ?? false,
      unpaged: json['unpaged'] ?? false,
    );
  }
}

// Updated Customer Due Model
class CustomerDue {
  final int id;
  final String shopId;
  final String name;
  final String? profileUrl;
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
    required this.name,
    this.profileUrl,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.creationDate,
    required this.customerId,
    required this.saleId,
    required this.partialPayments,
  });

  factory CustomerDue.fromJson(Map<String, dynamic> json) {
    return CustomerDue(
      id: json['id'] ?? 0,
      shopId: json['shopId'] ?? '',
      name: json['name'] ?? '',
      profileUrl: json['profileUrl'],
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
  String get customerName => name;
  
  // Get today's date for retrieval comparison
  bool get isDueToday {
    final today = DateTime.now();
    final dueDate = DateTime.tryParse(creationDate);
    if (dueDate == null) return false;
    return dueDate.year == today.year && 
           dueDate.month == today.month && 
           dueDate.day == today.day;
  }
}

// Partial Payment Model (unchanged)
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

// Updated Summary Model for Dashboard Cards
class DuesSummaryModel {
  final double totalGiven;
  final double totalCollected;
  final double totalRemaining;
  final double thisMonthCollection;
  final int totalCustomers;
  final int duesCustomers;
  final int paidCustomers;

  DuesSummaryModel({
    required this.totalGiven,
    required this.totalCollected,
    required this.totalRemaining,
    required this.thisMonthCollection,
    required this.totalCustomers,
    required this.duesCustomers,
    required this.paidCustomers,
  });

  factory DuesSummaryModel.fromDuesList(List<CustomerDue> dues) {
    double totalGiven = 0;
    double totalCollected = 0;
    double totalRemaining = 0;
    double thisMonthCollection = 0;
    int duesCustomers = 0;
    int paidCustomers = 0;
    
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    for (var due in dues) {
      totalGiven += due.totalDue;
      totalCollected += due.totalPaid;
      
      if (due.remainingDue > 0) {
        totalRemaining += due.remainingDue;
        duesCustomers++;
      } else {
        paidCustomers++;
      }

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
      duesCustomers: duesCustomers,
      paidCustomers: paidCustomers,
    );
  }
}