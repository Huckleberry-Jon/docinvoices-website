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
}