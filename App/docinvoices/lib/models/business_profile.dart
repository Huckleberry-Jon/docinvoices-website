class BusinessProfile {
  BusinessProfile({
    this.businessName = '',
    this.tagline = '',
    this.phone = '',
    this.email = '',
    this.website = '',
    this.street = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.taxRate = 0.0,
    this.logoPath = '',
  
    this.partsMarkupPercent = 10.0,
  });

  String businessName;
  String tagline;
  String phone;
  String email;
  String website;

  String street;
  String city;
  String state;
  String zip;

  double taxRate;
  String logoPath;
  double partsMarkupPercent;
  String get fullAddress {
    return [
      street,
      city,
      state,
      zip,
    ].where(
      (value) => value.trim().isNotEmpty,
    ).join(', ');
  }
}