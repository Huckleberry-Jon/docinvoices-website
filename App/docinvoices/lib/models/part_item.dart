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
  Map<String, dynamic> toJson() {
  return {
    'description': description,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'taxable': taxable,
  };
}

factory PartItem.fromJson(
  Map<String, dynamic> json,
) {
  return PartItem(
    description: json['description'] ?? '',
    quantity: (json['quantity'] ?? 0).toDouble(),
    unitPrice: (json['unitPrice'] ?? 0).toDouble(),
    taxable: json['taxable'] ?? true,
  );
}
}