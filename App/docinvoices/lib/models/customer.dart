class Customer {
  Customer({
    String? id,
    required this.name,
    this.company = '',
    this.phone = '',
    this.email = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.notes = '',
    this.preferredLanguage = 'en',
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  String id;
  String name;
  String company;
  String phone;
  String email;

  String street;
  String city;
  String state;
  String zip;

  String notes;
  String preferredLanguage;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'phone': phone,
      'email': email,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'notes': notes,
      'preferredLanguage': preferredLanguage,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
      notes: json['notes'] ?? '',
      preferredLanguage: json['preferredLanguage'] ?? 'en',
    );
  }
}