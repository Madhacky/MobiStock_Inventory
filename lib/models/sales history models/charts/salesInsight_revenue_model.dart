class SalesinsightRevenueModel {
  final String status;
  final String message;
  final Map<String, double> payload;
  final int statusCode;

  SalesinsightRevenueModel({
    required this.status,
    required this.message,
    required this.payload,
    required this.statusCode,
  });

  // Factory constructor to create an instance from JSON
  factory SalesinsightRevenueModel.fromJson(Map<String, dynamic> json) {
    return SalesinsightRevenueModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      payload: Map<String, double>.from(
        (json['payload'] as Map<String, dynamic>? ?? {}).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      statusCode: json['statusCode'] ?? 0,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'payload': payload,
      'statusCode': statusCode,
    };
  }

  // Method to get revenue for a specific month
  double? getRevenueForMonth(String month) {
    return payload[month];
  }

  // Method to get all months with revenue data
  List<String> getAvailableMonths() {
    return payload.keys.toList()..sort();
  }

  // Method to get total revenue across all months
  double getTotalRevenue() {
    return payload.values.fold(0.0, (sum, revenue) => sum + revenue);
  }

  // Method to get the month with highest revenue
  MapEntry<String, double>? getHighestRevenueMonth() {
    if (payload.isEmpty) return null;

    return payload.entries.reduce(
      (current, next) => current.value > next.value ? current : next,
    );
  }

  // Method to get the month with lowest revenue
  MapEntry<String, double>? getLowestRevenueMonth() {
    if (payload.isEmpty) return null;

    return payload.entries.reduce(
      (current, next) => current.value < next.value ? current : next,
    );
  }

  // Method to get average monthly revenue
  double getAverageRevenue() {
    if (payload.isEmpty) return 0.0;
    return getTotalRevenue() / payload.length;
  }

  @override
  String toString() {
    return 'SalesinsightRevenueModel(status: $status, message: $message, payload: $payload, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SalesinsightRevenueModel &&
        other.status == status &&
        other.message == message &&
        other.statusCode == statusCode &&
        _mapEquals(other.payload, payload);
  }

  @override
  int get hashCode {
    return status.hashCode ^
        message.hashCode ^
        payload.hashCode ^
        statusCode.hashCode;
  }

  // Helper method to compare maps
  bool _mapEquals(Map<String, double> map1, Map<String, double> map2) {
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }

    return true;
  }
}
