import 'labor_item.dart';
import 'part_item.dart';

class Operation {
  Operation({
    required this.title,
    required this.labor,
    required this.parts,
    this.notes = '',
    this.repairDescription = '',
  });

  String title;
  final List<LaborItem> labor;
  final List<PartItem> parts;
  String notes;
  String repairDescription;

  double get laborTotal =>
      labor.fold(0.0, (sum, item) => sum + item.total);

  double get partsTotal =>
      parts.fold(0.0, (sum, item) => sum + item.total);

  double get total => laborTotal + partsTotal;
}