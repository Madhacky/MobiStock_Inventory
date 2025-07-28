// Model for individual due entry
class DueDetails {
  final int id;
  final double totalDue;
  final double totalPaid;
  final double remainingDue;
  final List<int> creationDate;
  final List<int> paymentRetriableDate;
  final bool paid;

  DueDetails({
    required this.id,
    required this.totalDue,
    required this.totalPaid,
    required this.remainingDue,
    required this.creationDate,
    required this.paymentRetriableDate,
    required this.paid,
  });

  factory DueDetails.fromJson(Map<String, dynamic> json) {
    return DueDetails(
      id: json['id'] ?? 0,
      totalDue: (json['totalDue'] ?? 0).toDouble(),
      totalPaid: (json['totalPaid'] ?? 0).toDouble(),
      remainingDue: (json['remainingDue'] ?? 0).toDouble(),
      creationDate: List<int>.from(json['creationDate'] ?? []),
      paymentRetriableDate: List<int>.from(json['paymentRetriableDate'] ?? []),
      paid: json['paid'] ?? false,
    );
  }

  // Helper method to get formatted creation date
  String get formattedCreationDate {
    if (creationDate.length >= 3) {
      return '${creationDate[2].toString().padLeft(2, '0')}/${creationDate[1].toString().padLeft(2, '0')}/${creationDate[0]}';
    }
    return 'N/A';
  }

  // Helper method to get formatted payment retriable date
  String get formattedPaymentRetriableDate {
    if (paymentRetriableDate.length >= 3) {
      return '${paymentRetriableDate[2].toString().padLeft(2, '0')}/${paymentRetriableDate[1].toString().padLeft(2, '0')}/${paymentRetriableDate[0]}';
    }
    return 'N/A';
  }

  // Helper method to get days since due
  int get daysSinceDue {
    if (paymentRetriableDate.length >= 3) {
      DateTime dueDate = DateTime(paymentRetriableDate[0], paymentRetriableDate[1], paymentRetriableDate[2]);
      DateTime today = DateTime.now();
      return today.difference(dueDate).inDays;
    }
    return 0;
  }
}

// Model for customer with dues
class RetrievalDueCustomer {
  final int id;
  final String name;
  final String email;
  final String primaryPhone;
  final String location;
  final String primaryAddress;
  final List<DueDetails> duesList;

  RetrievalDueCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.primaryPhone,
    required this.location,
    required this.primaryAddress,
    required this.duesList,
  });

  factory RetrievalDueCustomer.fromJson(Map<String, dynamic> json) {
    return RetrievalDueCustomer(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      primaryPhone: json['primaryPhone'] ?? '',
      location: json['location'] ?? '',
      primaryAddress: json['primaryAddress'] ?? '',
      duesList: (json['duesList'] as List<dynamic>?)
              ?.map((item) => DueDetails.fromJson(item))
              .toList() ??
          [],
    );
  }

  // Helper method to get aggregated dues (for backward compatibility)
  DueDetails get dues {
    if (duesList.isEmpty) {
      return DueDetails(
        id: 0,
        totalDue: 0.0,
        totalPaid: 0.0,
        remainingDue: 0.0,
        creationDate: [],
        paymentRetriableDate: [],
        paid: true,
      );
    }

    // Aggregate all dues for this customer
    double totalDue = duesList.fold(0.0, (sum, due) => sum + due.totalDue);
    double totalPaid = duesList.fold(0.0, (sum, due) => sum + due.totalPaid);
    double remainingDue = duesList.fold(0.0, (sum, due) => sum + due.remainingDue);
    
    // Find the earliest due date
    DateTime? earliestDueDate;
    List<int> earliestPaymentRetriableDate = [];
    
    for (var due in duesList) {
      if (due.paymentRetriableDate.length >= 3) {
        DateTime dueDate = DateTime(due.paymentRetriableDate[0], due.paymentRetriableDate[1], due.paymentRetriableDate[2]);
        if (earliestDueDate == null || dueDate.isBefore(earliestDueDate)) {
          earliestDueDate = dueDate;
          earliestPaymentRetriableDate = due.paymentRetriableDate;
        }
      }
    }

    // Use the first due's creation date and ID for simplicity
    return DueDetails(
      id: duesList.first.id,
      totalDue: totalDue,
      totalPaid: totalPaid,
      remainingDue: remainingDue,
      creationDate: duesList.first.creationDate,
      paymentRetriableDate: earliestPaymentRetriableDate,
      paid: remainingDue <= 0,
    );
  }

  // Helper method to get status based on remaining due
  String get status {
    if (dues.remainingDue <= 0) return 'Paid';
    if (dues.daysSinceDue > 0) return 'Overdue';
    return 'Due Today';
  }

  // Helper method to get status color
  String get statusColor {
    if (dues.remainingDue <= 0) return '#51CF66'; // Green
    if (dues.daysSinceDue > 0) return '#FF6B6B'; // Red
    return '#FF9500'; // Orange
  }
}

// Model for API response
class RetrievalDueResponse {
  final String status;
  final String message;
  final RetrievalDuePayload payload;
  final int statusCode;

  RetrievalDueResponse({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory RetrievalDueResponse.fromJson(Map<String, dynamic> json) {
    return RetrievalDueResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: RetrievalDuePayload.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

// Model for payload
class RetrievalDuePayload {
  final List<RetrievalDueCustomer> customers;
  final int totalCount;

  RetrievalDuePayload({
    required this.customers,
    required this.totalCount,
  });

  factory RetrievalDuePayload.fromJson(Map<String, dynamic> json) {
    return RetrievalDuePayload(
      customers: (json['customers'] as List<dynamic>?)
              ?.map((item) => RetrievalDueCustomer.fromJson(item))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}