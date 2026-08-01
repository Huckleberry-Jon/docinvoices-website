import 'package:flutter/material.dart';

import '../models/job.dart';
import '../models/customer.dart';
import 'package:docinvoices/services/job_repository.dart';
import 'customer_picker_screen.dart';
import 'review_work_screen.dart';
import '../models/operation.dart';
import '../models/general_charge.dart';
import 'customer_screen.dart';
class NewJobScreen extends StatefulWidget {
  const NewJobScreen({
    super.key,
    required this.languageCode,
    this.job,
  });

  final String languageCode;
  final Job? job;

  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  Customer? selectedCustomer;
  final TextEditingController customerController =
      TextEditingController();

  final TextEditingController equipmentController =
      TextEditingController();

  final TextEditingController unitController =
      TextEditingController();

  final TextEditingController vinController =
      TextEditingController();
final locationController = TextEditingController();
  final mileageController = TextEditingController();
  final complaintController = TextEditingController();
  final serviceCallChargeController = TextEditingController(
  text: '250.00',
);
    @override
void initState() {
  super.initState();

  if (widget.job != null) {
    customerController.text = widget.job!.customerName;
    equipmentController.text = widget.job!.equipment;
    unitController.text = widget.job!.unitNumber;
    vinController.text = widget.job!.vin;
    locationController.text = widget.job!.location;
    mileageController.text = widget.job!.mileage;
    complaintController.text =
    widget.job!.operations.isNotEmpty
        ? widget.job!.operations.first.title
        : '';

final serviceCharge = widget.job!.generalCharges
    .where(
      (charge) =>
          charge.description == 'Service Call Charge' ||
          charge.description == 'Cargo por llamada de servicio',
    )
    .toList();

serviceCallChargeController.text =
    serviceCharge.isNotEmpty
        ? serviceCharge.first.amount.toStringAsFixed(2)
        : '0.00';
  }
}

 @override
void dispose() {
  customerController.dispose();
  equipmentController.dispose();
  unitController.dispose();
  vinController.dispose();
  locationController.dispose();
  mileageController.dispose();
  complaintController.dispose();
  serviceCallChargeController.dispose();

  super.dispose();
}
  void _startVoiceCapture() {
  final String customerName = customerController.text.trim();
  

  if (customerName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.languageCode == 'es'
              ? 'Ingrese el nombre del cliente.'
              : 'Please enter the customer name.',
        ),
      ),
    );

    return;
  }

  // EDIT MODE: update the existing job and return to Review Work.
  if (widget.job != null) {
    final Job existingJob = widget.job!;
    final String updatedComplaint =
    complaintController.text.trim();

if (existingJob.operations.isEmpty) {
  if (updatedComplaint.isNotEmpty) {
    existingJob.operations.add(
      Operation(
        title: updatedComplaint,
        labor: [],
        parts: [],
      ),
    );
  }
} else {
  existingJob.operations.first.title = updatedComplaint;
}

existingJob.generalCharges.removeWhere(
  (charge) =>
      charge.description == 'Service Call Charge' ||
      charge.description == 'Cargo por llamada de servicio',
);

final double updatedServiceCallCharge = double.tryParse(
      serviceCallChargeController.text.trim(),
    ) ??
    0.0;

if (updatedServiceCallCharge > 0) {
  existingJob.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Cargo por llamada de servicio'
          : 'Service Call Charge',
      amount: updatedServiceCallCharge,
    ),
  );
}

    existingJob.customerName = customerController.text.trim();
    existingJob.equipment = equipmentController.text.trim();
    existingJob.unitNumber = unitController.text.trim();
    existingJob.vin = vinController.text.trim();
    existingJob.location = locationController.text.trim();
    existingJob.mileage = mileageController.text.trim();
       Navigator.pop(context, existingJob);
    return;
  }

  // NEW JOB MODE: create the job and continue to Voice Capture.
  final Job job = Job.createEstimate(
    customerName: customerController.text.trim(),
    equipment: equipmentController.text.trim(),
    unitNumber: unitController.text.trim(),
    vin: vinController.text.trim(),
    location: locationController.text.trim(),
    mileage: mileageController.text.trim(),
  );
final String complaint = complaintController.text.trim();

if (complaint.isNotEmpty) {
  job.operations.add(
    Operation(
      title: complaint,
      labor: [],
      parts: [],
    ),
  );
}
final double serviceCallCharge = double.tryParse(
      serviceCallChargeController.text.trim(),
    ) ??
    0.0;

if (serviceCallCharge > 0) {
  job.generalCharges.add(
    GeneralCharge(
      description: widget.languageCode == 'es'
          ? 'Cargo por llamada de servicio'
          : 'Service Call Charge',
      amount: serviceCallCharge,
    ),
  );
}
  JobRepository.instance.addJob(job);

  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ReviewWorkScreen(
      languageCode: widget.languageCode,
      job: job,
    ),
  ),
);
}

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Orden de servicio' : 'Service Order'
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   TextField(
  controller: customerController,
  readOnly: true,
  onTap: () async {
    final Customer? customer = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CustomerPickerScreen(),
      ),
    );

    if (customer == null) return;

    setState(() {
      selectedCustomer = customer;
      customerController.text = customer.name;
    });
  },
  decoration: InputDecoration(
    label: Text(
  isSpanish ? 'Buscar cliente' : 'Search Customer',
),
    suffixIcon: const Icon(Icons.people),
  ),
),

    Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        icon: const Icon(Icons.person_add),
        label: Text(
          isSpanish ? 'Nuevo cliente' : 'New Customer',
        ),
        onPressed: () async {
          final Customer? customer = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CustomerScreen(),
            ),
          );

          if (customer != null) {
            customerController.text = customer.name;
          }
        },
      ),
    ),
  ],
),

const SizedBox(height: 16),

            TextField(
              controller: equipmentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: isSpanish
                    ? 'Equipo'
                    : 'Equipment',
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: unitController,
              decoration: InputDecoration(
                labelText: isSpanish
                    ? 'Unidad #'
                    : 'Unit #',
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: vinController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: isSpanish
                    ? 'VIN / Número de serie'
                    : 'VIN / Serial Number',
              ),
            ),
            const SizedBox(height: 16),

TextField(
  controller: locationController,
  textCapitalization: TextCapitalization.words,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Ubicación'
        : 'Location',
  ),
),
const SizedBox(height: 16),

TextField(
  controller: mileageController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Millaje'
        : 'Mileage',
  ),
),
TextField(
  controller: complaintController,
  minLines: 3,
  maxLines: 6,
  textCapitalization: TextCapitalization.sentences,
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Queja / Servicio solicitado'
        : 'Complaint / Requested Service',
    hintText: isSpanish
        ? 'Ejemplo: No arranca'
        : 'Example: No start',
  ),
),
TextField(
  controller: serviceCallChargeController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Cargo por llamada de servicio'
        : 'Service Call Charge',
    prefixText: '\$',
  ),
),

const SizedBox(height: 16),

const SizedBox(height: 16),
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _startVoiceCapture,
                child: Text(
  widget.job != null
      ? (isSpanish ? 'Guardar cambios' : 'Save Changes')
      : (isSpanish
          ? 'Continuar '
          : 'Continue'),
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}