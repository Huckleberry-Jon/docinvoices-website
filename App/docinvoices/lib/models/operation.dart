import 'labor_item.dart';
import 'part_item.dart';

class Operation {
  Operation({
    required this.title,
    required this.labor,
    required this.parts,
    this.notes = '',
    this.repairDescription = '',
    this.recommendation = '',
  });

  String title;
  final List<LaborItem> labor;
  final List<PartItem> parts;
  String notes;
  String repairDescription;
  String recommendation;

  double get laborTotal =>
      labor.fold(0.0, (sum, item) => sum + item.total);

  double get partsTotal =>
      parts.fold(0.0, (sum, item) => sum + item.total);

  double get total => laborTotal + partsTotal;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'notes': notes,
      'repairDescription': repairDescription,
      'recommendation': recommendation,
      'labor': labor.map((item) => item.toJson()).toList(),
      'parts': parts.map((item) => item.toJson()).toList(),
    };
  }

  factory Operation.fromJson(
    Map<String, dynamic> json,
  ) {
    return Operation(
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      repairDescription:
          json['repairDescription'] ?? '',
          recommendation: json['recommendation'] ?? '',
      labor: (json['labor'] as List? ?? [])
          .map(
            (item) => LaborItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      parts: (json['parts'] as List? ?? [])
          .map(
            (item) => PartItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}