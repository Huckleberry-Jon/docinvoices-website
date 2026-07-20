import 'general_charge.dart';
import 'operation.dart';
class Job {
  Job({
    required this.customerName,
    required this.equipment,
    required this.unitNumber,
    required this.vin,
    required this.transcription,
    required this.mileage,
    required this.poNumber,
    required this.completedDate,
    required this.estimatedTotal,
    required this.laborHours,
required this.laborRate,
required this.partsCost,
required this.markupPercent,
required this.taxLabor,
required this.taxParts,
required this.isTaxExempt,
required this.discountAmount,

this.operations = const [],
this.generalCharges = const [],
  });

  String customerName;
  String equipment;
  String unitNumber;
  String vin;
  String transcription;
  String mileage;
  String poNumber;
  String completedDate;
  String estimatedTotal;
  double laborHours;
double laborRate;
double partsCost;
double markupPercent;
bool taxLabor;
bool taxParts;
bool isTaxExempt;
double discountAmount;
final List<Operation> operations;
final List<GeneralCharge> generalCharges;
}