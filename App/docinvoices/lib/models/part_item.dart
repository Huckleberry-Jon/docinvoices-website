class PartItem {
  const PartItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.taxable = true,
  });

  final String description;
  final double quantity;
  final double unitPrice;
  final bool taxable;

  double get total => quantity * unitPrice;
}