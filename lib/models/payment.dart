enum PaymentStatus {
  pending,
  success,
  failed,
  cancelled,
}

class Payment {
  String id;
  String paymentMethod;
  double amount;
  DateTime paymentDate;

  String customerId;

  Payment({
    required this.id,
    required this.paymentMethod,
    required this.amount,
    required this.paymentDate,
    required this.customerId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      paymentMethod: json['payment_method'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['payment_date']),
      customerId: json['customer_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_method': paymentMethod,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'customer_id': customerId,
    };
  }
}
