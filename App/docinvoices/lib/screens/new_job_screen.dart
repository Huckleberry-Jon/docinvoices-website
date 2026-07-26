import 'package:flutter/material.dart';
import 'voice_capture_screen.dart';
import '../models/job.dart';
import '../models/customer.dart';
import 'package:docinvoices/services/job_repository.dart';
import 'customer_picker_screen.dart';

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
  }
}

  @override
  void dispose() {
    customerController.dispose();
    equipmentController.dispose();
    unitController.dispose();
    vinController.dispose();
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

  JobRepository.instance.addJob(job);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VoiceCaptureScreen(
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
          isSpanish ? 'Crear estimado' : 'Create Estimate',
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
    labelText: isSpanish
        ? 'Nombre del cliente'
        : 'Customer Name',
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
              builder: (_) => const CustomerPickerScreen(),
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
            const SizedBox(height: 32),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _startVoiceCapture,
                child: Text(
  widget.job != null
      ? (isSpanish ? 'Guardar cambios' : 'Save Changes')
      : (isSpanish
          ? 'Continuar a captura de voz'
          : 'Continue to Voice Capture'),
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}