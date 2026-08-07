class PartItem {
  const PartItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    this.unitCost = 0,
    this.markupPercent = 0,
    this.taxable = true,
  });

  final String description;
  final double quantity;

  // What the customer pays for one part.
  final double unitPrice;

  // What the business paid for one part.
  final double unitCost;

  final double markupPercent;
  final bool taxable;

  double get total => quantity * unitPrice;

  double get totalCost => quantity * unitCost;

  double get markupPerUnit => unitPrice - unitCost;

  double get totalMarkup => total - totalCost;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'unitCost': unitCost,
      'markupPercent': markupPercent,
      'taxable': taxable,
    };
  }

  factory PartItem.fromJson(
    Map<String, dynamic> json,
  ) {
    final unitPrice =
        (json['unitPrice'] ?? 0).toDouble();

    return PartItem(
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unitPrice: unitPrice,
      unitCost:
          (json['unitCost'] ?? unitPrice).toDouble(),
      markupPercent:
          (json['markupPercent'] ?? 0).toDouble(),
      taxable: json['taxable'] ?? true,
    );
  }
}