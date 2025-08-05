// Models
class Sale {
  final int saleId;
  final int customerId;
  final String companName;
  final int quantity;
  final String companyModel;
  final String invoiceNumber;
  final String customerName;
  final String variant;
  final String color;
  final String paymentMethod;
  final String paymentMode;
  final DateTime saleDate;
  final String invoicePdfUrl;
  final double amount;

  Sale({
    required this.saleId,
    required this.customerId,
    required this.companName,
    required this.quantity,
    required this.companyModel,
    required this.invoiceNumber,
    required this.customerName,
    required this.variant,
    required this.color,
    required this.paymentMethod,
    required this.paymentMode,
    required this.saleDate,
    required this.invoicePdfUrl,
    required this.amount,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      saleId: json['saleId'],
      customerId: json['customerId'],
      companName: json['companName'],
      quantity: json['quantity'],
      companyModel: json['companyModel'],
      invoiceNumber: json['invoiceNumber'],
      customerName: json['customerName'],
      variant: json['variant'] ?? '',
      color: json['color'] ?? '',
      paymentMethod: json['paymentMethod'],
      paymentMode: json['paymentMode'],
      saleDate: DateTime.parse(json['saleDate']),
      invoicePdfUrl: json['invoicePdfUrl'],
      amount: double.parse(json['amount']),
    );
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';
  String get formattedDate => '${saleDate.day}/${saleDate.month}/${saleDate.year}';
  String get formattedTime => '${saleDate.hour}:${saleDate.minute.toString().padLeft(2, '0')}';
}


class SalesHistoryResponse {
  final String status;
  final String message;
  final SalesHistoryPayload payload;

  SalesHistoryResponse({
    required this.status,
    required this.message,
    required this.payload,
  });

  factory SalesHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SalesHistoryResponse(
      status: json['status'],
      message: json['message'],
      payload: SalesHistoryPayload.fromJson(json['payload']),
    );
  }
}

class SalesHistoryPayload {
  final List<Sale> content;
  final int totalElements;
  final int totalPages;
  final bool last;

  SalesHistoryPayload({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory SalesHistoryPayload.fromJson(Map<String, dynamic> json) {
    return SalesHistoryPayload(
      content: (json['page']['content'] as List).map((item) => Sale.fromJson(item)).toList(),
      totalElements: json['page']['totalElements'] ?? 0,
      totalPages: json['page']['totalPages'] ?? 1,
      last: json['page']['last'] ?? true,
    );
  }
}
