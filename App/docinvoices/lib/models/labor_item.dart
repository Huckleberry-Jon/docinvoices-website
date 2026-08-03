class LaborItem {
  const LaborItem({
    required this.description,
    required this.hours,
    required this.rate,
  });

  final String description;
  final double hours;
  final double rate;

  double get total => hours * rate;
  Map<String, dynamic> toJson() {
  return {
    'description': description,
    'hours': hours,
    'rate': rate,
  };
}

factory LaborItem.fromJson(
  Map<String, dynamic> json,
) {
  return LaborItem(
    description: json['description'] ?? '',
    hours: (json['hours'] ?? 0).toDouble(),
    rate: (json['rate'] ?? 0).toDouble(),
  );
}
}