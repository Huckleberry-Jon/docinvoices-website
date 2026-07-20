import 'labor_item.dart';
import 'part_item.dart';

class Operation {
  const Operation({
    required this.title,
    required this.labor,
required this.parts,
    this.notes = '',
  });

  final String title;
  final List<LaborItem> labor;
  final List<PartItem> parts;
  final String notes;

  double get laborTotal =>
      labor.fold(0.0, (sum, item) => sum + item.total);

  double get partsTotal =>
      parts.fold(0.0, (sum, item) => sum + item.total);

  double get total => laborTotal + partsTotal;
}