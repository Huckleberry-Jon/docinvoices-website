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
}