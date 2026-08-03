class Payment {
  Payment({
    required this.method,
    required this.amount,
    this.reference = '',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  final String method;
  final double amount;
  final String reference;
  final DateTime date;
  Map<String, dynamic> toJson() {
  return {
    'method': method,
    'amount': amount,
    'reference': reference,
    'date': date.toIso8601String(),
  };
}

factory Payment.fromJson(
  Map<String, dynamic> json,
) {
  return Payment(
    method: json['method'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    reference: json['reference'] ?? '',
    date: json['date'] == null
        ? DateTime.now()
        : DateTime.parse(json['date']),
  );
}
}