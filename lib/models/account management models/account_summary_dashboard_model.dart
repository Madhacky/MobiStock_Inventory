class AccountSummaryDashboardModel {
  final String status;
  final String message;
  final Payload payload;
  final int statusCode;

  AccountSummaryDashboardModel({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  factory AccountSummaryDashboardModel.fromJson(Map<String, dynamic> json) {
    return AccountSummaryDashboardModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: Payload.fromJson(json['payload'] ?? {}),
      statusCode: json['statusCode'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload.toJson(),
      'statusCode': statusCode,
    };
  }
}

class Payload {
  final String shopId;
  final List<int> date;
  final double openingBalance;
  final double totalCredit;
  final double totalDebit;
  final double closingBalance;
  final Sale sale;
  final double emiReceivedToday;
  final double duesRecovered;
  final double payBills;
  final double withdrawals;
  final double commissionReceived;
  final Gst gst;
  final Map<String, double> creditByAccount;
  final Map<String, double> debitByAccount;

  Payload({
    required this.shopId,
    required this.date,
    required this.openingBalance,
    required this.totalCredit,
    required this.totalDebit,
    required this.closingBalance,
    required this.sale,
    required this.emiReceivedToday,
    required this.duesRecovered,
    required this.payBills,
    required this.withdrawals,
    required this.commissionReceived,
    required this.gst,
    required this.creditByAccount,
    required this.debitByAccount,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
  return Payload(
    shopId: json['shopId'] ?? '',
    date: List<int>.from(json['date'] ?? []),
    openingBalance: (json['openingBalance'] ?? 0).toDouble(),
    totalCredit: (json['totalCredit'] ?? 0).toDouble(),
    totalDebit: (json['totalDebit'] ?? 0).toDouble(),
    closingBalance: (json['closingBalance'] ?? 0).toDouble(),
    sale: Sale.fromJson(json['sale'] ?? {}),
    emiReceivedToday: (json['emiReceivedToday'] ?? 0).toDouble(),
    duesRecovered: (json['duesRecovered'] ?? 0).toDouble(),
    payBills: (json['payBills'] ?? 0).toDouble(),
    withdrawals: (json['withdrawals'] ?? 0).toDouble(),
    commissionReceived: (json['commissionReceived'] ?? 0).toDouble(),
    gst: Gst.fromJson(json['gst'] ?? {}),
    
    creditByAccount: Map<String, double>.from(
      (json['creditByAccount'] ?? {})
          .map((key, value) => MapEntry(key.toString(), (value ?? 0).toDouble())),
    ),
    debitByAccount: Map<String, double>.from(
      (json['debitByAccount'] ?? {})
          .map((key, value) => MapEntry(key.toString(), (value ?? 0).toDouble())),
    ),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'date': date,
      'openingBalance': openingBalance,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'closingBalance': closingBalance,
      'sale': sale.toJson(),
      'emiReceivedToday': emiReceivedToday,
      'duesRecovered': duesRecovered,
      'payBills': payBills,
      'withdrawals': withdrawals,
      'commissionReceived': commissionReceived,
      'gst': gst.toJson(),
      'creditByAccount': creditByAccount,
      'debitByAccount': debitByAccount,
    };
  }
}

class Sale {
  final double totalSale;
  final double downPayment;
  final double givenAsDues;
  final double pendingEMI;

  Sale({
    required this.totalSale,
    required this.downPayment,
    required this.givenAsDues,
    required this.pendingEMI,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      totalSale: (json['totalSale'] ?? 0).toDouble(),
      downPayment: (json['downPayment'] ?? 0).toDouble(),
      givenAsDues: (json['givenAsDues'] ?? 0).toDouble(),
      pendingEMI: (json['pendingEMI'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSale': totalSale,
      'downPayment': downPayment,
      'givenAsDues': givenAsDues,
      'pendingEMI': pendingEMI,
    };
  }
}

class Gst {
  final double gstOnSales;
  final double gstOnPurchases;
  final double netGst;

  Gst({
    required this.gstOnSales,
    required this.gstOnPurchases,
    required this.netGst,
  });

  factory Gst.fromJson(Map<String, dynamic> json) {
    return Gst(
      gstOnSales: (json['gstOnSales'] ?? 0).toDouble(),
      gstOnPurchases: (json['gstOnPurchases'] ?? 0).toDouble(),
      netGst: (json['netGst'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gstOnSales': gstOnSales,
      'gstOnPurchases': gstOnPurchases,
      'netGst': netGst,
    };
  }
}
