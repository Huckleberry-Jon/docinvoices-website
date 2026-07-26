class Invoice {
    Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.equipment,
    required this.unitNumber,
    required this.vin,
    required this.servicesPerformed,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.balance,
    required this.status,
    required this.createdDate,
    this.sentDate,
    this.paidDate,
  });

  final String id;
  final String invoiceNumber;

  final String customerName;
  final String customerEmail;
  final String customerPhone;

  final String equipment;
  final String unitNumber;
  final String vin;

  final String servicesPerformed;

  final double subtotal;
  final double tax;
  final double total;
  final double balance;

  /// Draft, Sent, Paid, Overdue
  final String status;

  final DateTime createdDate;
  final DateTime? sentDate;
  final DateTime? paidDate;
}