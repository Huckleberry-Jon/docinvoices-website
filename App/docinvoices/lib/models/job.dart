import 'general_charge.dart';
import 'operation.dart';
import 'payment.dart';

class Job {
  Job({
    
    required this.location,
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
    required this.operations,
    required this.generalCharges,
    this.estimateNumber = '',
    this.repairOrderNumber = '',
    this.invoiceNumber = '',
    this.jobStatus = 'Estimate',
    this.scheduledDateTime,
this.reminderDateTime,
this.reminderEnabled = false,
this.notes = '',
this.payments = const [],
this.beforePhotoPaths = const [],
this.afterPhotoPaths = const [],
  });

  factory Job.createEstimate({
    required String location,
    required String customerName,
    required String equipment,
    required String unitNumber,
    required String vin,
    required String mileage,
    
  }) {
    return Job(
      location: location,
      customerName: customerName,
      equipment: equipment,
      unitNumber: unitNumber,
      vin: vin,
      transcription: '',
      mileage: mileage,
      poNumber: '',
      completedDate: '',
      estimatedTotal: '0.00',
      laborHours: 0,
      laborRate: 0,
      partsCost: 0,
      markupPercent: 0,
      taxLabor: false,
      taxParts: false,
      isTaxExempt: false,
      discountAmount: 0,
      operations: [],
      generalCharges: [],
      estimateNumber: '',
      repairOrderNumber: '',
      invoiceNumber: '',
      jobStatus: 'Estimate',
      
    );
  }

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
  double discountAmount;

  bool taxLabor;
  bool taxParts;
  bool isTaxExempt;

  String estimateNumber;
  String repairOrderNumber;
  String invoiceNumber;
  String jobStatus;
  String notes;
  DateTime? scheduledDateTime;
DateTime? reminderDateTime;
bool reminderEnabled;

  final List<Operation> operations;
  final List<Payment> payments;
  final List<GeneralCharge> generalCharges;
  final List<String> beforePhotoPaths;
final List<String> afterPhotoPaths;
  String location;

double get totalPaid {
  return payments.fold(
    0.0,
    (sum, payment) => sum + payment.amount,
  );
}

double get balanceDue {
  final double total =
      double.tryParse(estimatedTotal) ?? 0.0;

  return total - totalPaid;
}

bool get isPaidInFull {
  return balanceDue <= 0.01;
}
}