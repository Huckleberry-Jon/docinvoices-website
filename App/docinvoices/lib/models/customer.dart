class Customer {
  Customer({
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
  });

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
  
}