import 'general_charge.dart';
import 'operation.dart';
import 'payment.dart';

class Job {
  Job({
    
    required this.location,
    required this.customerPhone,
required this.customerEmail,
    required this.customerName,
    required this.equipment,
    required this.unitNumber,
    required this.vin,
    this.esn = '',
this.tsn = '',
this.vehicleYear = '',
this.vehicleMake = '',
this.vehicleModel = '',
this.engineManufacturer = '',
this.engineModel = '',
this.vehicleType = '',
this.bodyClass = '',
this.fuelType = '',
this.gvwrClass = '',
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
this.approvalStatus = '',
this.approvalMethod = '',
this.approvalRequestedBy = '',
this.approvalDate,
this.scheduledDateTime,
this.reminderDateTime,
this.reminderEnabled = false,
this.notes = '',
List<Payment>? payments,
List<String>? beforePhotoPaths,
List<String>? afterPhotoPaths,
List<String>? receiptPhotoPaths,
}) : payments = payments ?? <Payment>[],
      beforePhotoPaths =
    beforePhotoPaths ?? [],
afterPhotoPaths =
    afterPhotoPaths ?? [],
receiptPhotoPaths =
    receiptPhotoPaths ?? [];

  factory Job.createEstimate({
    required String location,
    required String customerName,
    required String customerPhone,
required String customerEmail,
    required String equipment,
    required String unitNumber,
    required String vin,
    required String mileage,
    
  }) {
    return Job(
      location: location,
      customerName: customerName,
      customerPhone: customerPhone,
customerEmail: customerEmail,
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
  String customerPhone;
String customerEmail;
  String equipment;
  String unitNumber;
  String vin;
  String esn;
String tsn;
String vehicleYear;
String vehicleMake;
String vehicleModel;
String engineManufacturer;
String engineModel;
String vehicleType;
String bodyClass;
String fuelType;
String gvwrClass;
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

String approvalStatus;
String approvalMethod;
String approvalRequestedBy;
DateTime? approvalDate;

String notes;
  DateTime? scheduledDateTime;
DateTime? reminderDateTime;
bool reminderEnabled;

  final List<Operation> operations;
  final List<Payment> payments;
  final List<GeneralCharge> generalCharges;
  final List beforePhotoPaths;
final List afterPhotoPaths;
final List receiptPhotoPaths;

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
Map<String, dynamic> toJson() {
  return {
    'location': location,
    'customerName': customerName,
    'customerPhone': customerPhone,
'customerEmail': customerEmail,
    'equipment': equipment,
    'unitNumber': unitNumber,
    'vin': vin,
    'esn': esn,
'tsn': tsn,
'vehicleYear': vehicleYear,
'vehicleMake': vehicleMake,
'vehicleModel': vehicleModel,
'engineManufacturer': engineManufacturer,
'engineModel': engineModel,
'vehicleType': vehicleType,
'bodyClass': bodyClass,
'fuelType': fuelType,
'gvwrClass': gvwrClass,
'transcription': transcription,
    'mileage': mileage,
    'poNumber': poNumber,
    'completedDate': completedDate,
    'estimatedTotal': estimatedTotal,
    'laborHours': laborHours,
    'laborRate': laborRate,
    'partsCost': partsCost,
    'markupPercent': markupPercent,
    'taxLabor': taxLabor,
    'taxParts': taxParts,
    'isTaxExempt': isTaxExempt,
    'discountAmount': discountAmount,
    'estimateNumber': estimateNumber,
    'repairOrderNumber': repairOrderNumber,
    'invoiceNumber': invoiceNumber,
    'jobStatus': jobStatus,
'approvalStatus': approvalStatus,
'approvalMethod': approvalMethod,
'approvalRequestedBy': approvalRequestedBy,
'approvalDate': approvalDate?.toIso8601String(),
'notes': notes,
    'scheduledDateTime':
        scheduledDateTime?.toIso8601String(),
    'reminderDateTime':
        reminderDateTime?.toIso8601String(),
    'reminderEnabled': reminderEnabled,
    'operations':
        operations.map((item) => item.toJson()).toList(),
    'payments':
        payments.map((item) => item.toJson()).toList(),
    'generalCharges':
        generalCharges.map((item) => item.toJson()).toList(),
    'beforePhotoPaths': beforePhotoPaths,
'afterPhotoPaths': afterPhotoPaths,
'receiptPhotoPaths': receiptPhotoPaths,
  };
}

factory Job.fromJson(
  Map<String, dynamic> json,
) {
  return Job(
    location: json['location'] ?? '',
    customerName: json['customerName'] ?? '',
    customerPhone: json['customerPhone'] ?? '',
customerEmail: json['customerEmail'] ?? '',
    equipment: json['equipment'] ?? '',
    unitNumber: json['unitNumber'] ?? '',
    vin: json['vin'] ?? '',
    esn: json['esn'] ?? '',
tsn: json['tsn'] ?? '',
vehicleYear: json['vehicleYear'] ?? '',
vehicleMake: json['vehicleMake'] ?? '',
vehicleModel: json['vehicleModel'] ?? '',
engineManufacturer:
    json['engineManufacturer'] ?? '',
engineModel: json['engineModel'] ?? '',
vehicleType: json['vehicleType'] ?? '',
bodyClass: json['bodyClass'] ?? '',
fuelType: json['fuelType'] ?? '',
gvwrClass: json['gvwrClass'] ?? '',
transcription: json['transcription'] ?? '',
    mileage: json['mileage'] ?? '',
    poNumber: json['poNumber'] ?? '',
    completedDate: json['completedDate'] ?? '',
    estimatedTotal: json['estimatedTotal'] ?? '0.00',
    laborHours: (json['laborHours'] ?? 0).toDouble(),
    laborRate: (json['laborRate'] ?? 0).toDouble(),
    partsCost: (json['partsCost'] ?? 0).toDouble(),
    markupPercent:
        (json['markupPercent'] ?? 0).toDouble(),
    taxLabor: json['taxLabor'] ?? false,
    taxParts: json['taxParts'] ?? false,
    isTaxExempt: json['isTaxExempt'] ?? false,
    discountAmount:
        (json['discountAmount'] ?? 0).toDouble(),
    estimateNumber: json['estimateNumber'] ?? '',
    repairOrderNumber:
        json['repairOrderNumber'] ?? '',
    invoiceNumber: json['invoiceNumber'] ?? '',
    jobStatus: json['jobStatus'] ?? 'Estimate',
approvalStatus: json['approvalStatus'] ?? '',
approvalMethod: json['approvalMethod'] ?? '',
approvalRequestedBy:
    json['approvalRequestedBy'] ?? '',
approvalDate: json['approvalDate'] == null
    ? null
    : DateTime.tryParse(
        json['approvalDate'],
      ),
notes: json['notes'] ?? '',
    scheduledDateTime:
        json['scheduledDateTime'] == null
            ? null
            : DateTime.tryParse(
                json['scheduledDateTime'],
              ),
    reminderDateTime:
        json['reminderDateTime'] == null
            ? null
            : DateTime.tryParse(
                json['reminderDateTime'],
              ),
    reminderEnabled:
        json['reminderEnabled'] ?? false,
    operations: (json['operations'] as List? ?? [])
        .map(
          (item) => Operation.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(),
    payments: (json['payments'] as List? ?? [])
        .map(
          (item) => Payment.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(),
    generalCharges:
        (json['generalCharges'] as List? ?? [])
            .map(
              (item) => GeneralCharge.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(),
    beforePhotoPaths:
    (json['beforePhotoPaths'] as List? ?? [])
        .map((item) => item.toString())
        .toList(),

afterPhotoPaths:
    (json['afterPhotoPaths'] as List? ?? [])
        .map((item) => item.toString())
        .toList(),

receiptPhotoPaths:
    (json['receiptPhotoPaths'] as List? ?? [])
        .map((item) => item.toString())
        .toList(),
);
}
}