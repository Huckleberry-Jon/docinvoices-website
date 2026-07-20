class BusinessSettings {
  const BusinessSettings({
    this.defaultLaborRate = 0.0,
    this.defaultMileageRate = 0.0,
    this.defaultTaxRate = 0.0,
    this.currencyCode = 'USD',
    this.defaultLanguage = 'English',
    this.itemizedInvoices = true,
  });

  final double defaultLaborRate;
  final double defaultMileageRate;
  final double defaultTaxRate;
  final String currencyCode;
  final String defaultLanguage;
  final bool itemizedInvoices;

  BusinessSettings copyWith({
    double? defaultLaborRate,
    double? defaultMileageRate,
    double? defaultTaxRate,
    String? currencyCode,
    String? defaultLanguage,
    bool? itemizedInvoices,
  }) {
    return BusinessSettings(
      defaultLaborRate: defaultLaborRate ?? this.defaultLaborRate,
      defaultMileageRate:
          defaultMileageRate ?? this.defaultMileageRate,
      defaultTaxRate: defaultTaxRate ?? this.defaultTaxRate,
      currencyCode: currencyCode ?? this.currencyCode,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      itemizedInvoices:
          itemizedInvoices ?? this.itemizedInvoices,
    );
  }
}