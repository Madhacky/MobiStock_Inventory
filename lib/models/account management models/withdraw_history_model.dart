class Withdraw {
  final int id;
  final List<int> date;
  final double amount;
  final String withdrawnBy;
  final String purpose;
  final String notes;
  final String paymentMode;

  Withdraw({
    required this.id,
    required this.date,
    required this.amount,
    required this.withdrawnBy,
    required this.purpose,
    required this.notes,
    required this.paymentMode,
  });

  factory Withdraw.fromJson(Map<String, dynamic> json) {
    return Withdraw(
      id: json['id'] ?? 0,
      date: List<int>.from(json['date'] ?? []),
      amount: (json['amount'] ?? 0).toDouble(),
      withdrawnBy: json['withdrawnBy'] ?? '',
      purpose: json['purpose'] ?? '',
      notes: json['notes'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'withdrawnBy': withdrawnBy,
      'purpose': purpose,
      'notes': notes,
      'paymentMode': paymentMode,
    };
  }

  DateTime get formattedDate {
    if (date.length >= 3) {
      return DateTime(date[0], date[1], date[2]);
    }
    return DateTime.now();
  }

  String get formattedAmount {
    return '₹${amount.toStringAsFixed(0)}';
  }
}

class WithdrawalsResponse {
  final List<Withdraw> content;
  final bool last;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;
  final bool first;
  final int numberOfElements;
  final bool empty;

  WithdrawalsResponse({
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

  factory WithdrawalsResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalsResponse(
      content: (json['content'] as List<dynamic>?)
              ?.map((item) => Withdraw.fromJson(item as Map<String, dynamic>))
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

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((item) => item.toJson()).toList(),
      'last': last,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'size': size,
      'number': number,
      'first': first,
      'numberOfElements': numberOfElements,
      'empty': empty,
    };
  }
}