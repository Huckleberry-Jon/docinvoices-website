class GeneralCharge {
  const GeneralCharge({
    required this.description,
    required this.amount,
    this.taxable = false,
  });

  final String description;
  final double amount;
  final bool taxable;
}