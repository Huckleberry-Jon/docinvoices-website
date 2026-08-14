class CustomerUnit {
  CustomerUnit({
    this.customerId = '',
    required this.customerName,
    this.unitNumber = '',
    this.vin = '',
    this.year = '',
    this.make = '',
    this.model = '',
    this.mileage = '',
    this.esn = '',
    this.tsn = '',
    this.notes = '',
  });

  String customerId;
  String customerName;
  String unitNumber;
  String vin;
  String year;
  String make;
  String model;
  String mileage;
  String esn;
  String tsn;
  String notes;

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'unitNumber': unitNumber,
      'vin': vin,
      'year': year,
      'make': make,
      'model': model,
      'mileage': mileage,
      'esn': esn,
      'tsn': tsn,
      'notes': notes,
    };
  }

  factory CustomerUnit.fromJson(Map<String, dynamic> json) {
    return CustomerUnit(
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      unitNumber: json['unitNumber'] ?? '',
      vin: json['vin'] ?? '',
      year: json['year'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      mileage: json['mileage'] ?? '',
      esn: json['esn'] ?? '',
      tsn: json['tsn'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}