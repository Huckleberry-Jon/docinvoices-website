class GeneralCharge {
  const GeneralCharge({
    required this.description,
    required this.amount,
    this.taxable = false,
  });

  final String description;
  final double amount;
  final bool taxable;
  Map<String, dynamic> toJson() {
  return {
    'description': description,
    'amount': amount,
    'taxable': taxable,
  };
}

factory GeneralCharge.fromJson(
  Map<String, dynamic> json,
) {
  return GeneralCharge(
    description: json['description'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    taxable: json['taxable'] ?? false,
  );
}
}