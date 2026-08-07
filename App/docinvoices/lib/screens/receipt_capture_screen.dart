import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/job.dart';
import '../services/job_repository.dart';

class ReceiptCaptureScreen extends StatefulWidget {
  const ReceiptCaptureScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<ReceiptCaptureScreen> createState() =>
      _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState
    extends State<ReceiptCaptureScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  String? receiptPath;

  bool get isSpanish =>
      widget.languageCode == 'es';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takeReceiptPhoto();
    });
  }

  Future<void> _takeReceiptPhoto() async {
    final XFile? photo =
        await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (!mounted) return;

    if (photo == null) {
  if (receiptPath == null) {
    Navigator.pop(context);
  }
  return;
}

    final appDirectory =
    await getApplicationDocumentsDirectory();

final receiptDirectory = Directory(
  '${appDirectory.path}/receipts',
);

if (!await receiptDirectory.exists()) {
  await receiptDirectory.create(recursive: true);
}

final savedPath =
    '${receiptDirectory.path}/receipt_'
    '${DateTime.now().microsecondsSinceEpoch}.jpg';

await File(photo.path).copy(savedPath);

if (!mounted) return;

setState(() {
  receiptPath = savedPath;
});
  }

  void _assignToWorkOrder() {
    final activeJobs =
        JobRepository.instance.activeJobs;

    if (activeJobs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSpanish
                ? 'No hay órdenes de trabajo activas.'
                : 'No active work orders found.',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          const Color(0xFF07111D),
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Text(
                  isSpanish
                      ? 'Asignar a orden de trabajo'
                      : 'Assign to Work Order',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              ...activeJobs.map(
                (Job job) {
                  return ListTile(
                    leading: const Icon(
                      Icons.work_outline,
                      color: Colors.blue,
                    ),
                    title: Text(
                      job.customerName,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      [
                        job.equipment,
                        job.unitNumber,
                      ]
                          .where(
                            (value) =>
                                value
                                    .trim()
                                    .isNotEmpty,
                          )
                          .join(' • '),
                      style: const TextStyle(
                        color:
                            Colors.white60,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(
                        sheetContext,
                      );

                      _saveToJob(job);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveToJob(Job job) async {
    if (receiptPath == null) return;

    // Temporary Version 1 storage.
    // We will wire this to a dedicated
    // receipt list on Job next.
    job.receiptPhotoPaths.add(receiptPath!);

    JobRepository.instance.updateJob(job);
await JobRepository.instance.save();

if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'Recibo asignado a la orden de trabajo.'
              : 'Receipt assigned to work order.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _addToInventory() {
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      isSpanish
          ? 'El inventario estará disponible próximamente.'
          : 'Inventory is coming soon.',
    ),
  ),
);
  }

  void _businessExpense() {
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      isSpanish
          ? 'Los gastos comerciales estarán disponibles próximamente.'
          : 'Business expenses are coming soon.',
    ),
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveJobs =
    JobRepository.instance.activeJobs.isNotEmpty;
    return Scaffold(
      backgroundColor:
          const Color(0xFF050B14),
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Recibo'
              : 'Receipt',
        ),
      ),
      body: receiptPath == null
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
  child: GestureDetector(
    onTap: _takeReceiptPhoto,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.file(
        File(receiptPath!),
        width: double.infinity,
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                    const SizedBox(height: 18),

                    SizedBox(
  width: double.infinity,
  child: FilledButton.icon(
    onPressed:
        hasActiveJobs ? _assignToWorkOrder : null,
    icon: const Icon(
      Icons.work_outline,
    ),
    label: Text(
      hasActiveJobs
          ? (isSpanish
              ? 'Asignar a orden de trabajo'
              : 'Assign to Work Order')
          : (isSpanish
              ? 'No hay órdenes de trabajo activas'
              : 'No Active Work Orders'),
    ),
  ),
),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child:
                          OutlinedButton.icon(
                       onPressed: _addToInventory,
                        icon: const Icon(
  Icons.inventory_2_outlined,
),
                        label: Text(
  isSpanish
      ? 'Agregar al inventario'
      : 'Add to Inventory',
),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child:
                          OutlinedButton.icon(
                        onPressed: _businessExpense,
                        icon: const Icon(
  Icons.business_center_outlined,
),
                        label: Text(
  isSpanish
      ? 'Gasto comercial'
      : 'Business Expense',
),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton.icon(
                      onPressed:
                          _takeReceiptPhoto,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                      ),
                      label: Text(
                        isSpanish
                            ? 'Volver a tomar'
                            : 'Retake Photo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}