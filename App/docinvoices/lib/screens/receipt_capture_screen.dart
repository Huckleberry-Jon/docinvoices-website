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

 Future<void> _pickReceiptImage(
  ImageSource source,
) async {
  final XFile? image = await _imagePicker.pickImage(
    source: source,
    imageQuality: 85,
  );

  if (!mounted) return;

  if (image == null) {
  return;
}

  final appDirectory =
      await getApplicationDocumentsDirectory();

  final receiptDirectory = Directory(
    '${appDirectory.path}/receipts',
  );

  if (!await receiptDirectory.exists()) {
    await receiptDirectory.create(
      recursive: true,
    );
  }

  final savedPath =
      '${receiptDirectory.path}/receipt_'
      '${DateTime.now().microsecondsSinceEpoch}.jpg';

  await File(image.path).copy(savedPath);

  if (!mounted) return;

  setState(() {
    receiptPath = savedPath;
  });
}

Future<void> _takeReceiptPhoto() async {
  await _pickReceiptImage(
    ImageSource.camera,
  );
}

Future<void> _chooseReceiptFromLibrary() async {
  await _pickReceiptImage(
    ImageSource.gallery,
  );
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
Future<void> _viewSavedReceipts() async {
  final appDirectory =
      await getApplicationDocumentsDirectory();

  final receiptDirectory = Directory(
    '${appDirectory.path}/receipts',
  );

  if (!await receiptDirectory.exists()) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No hay recibos guardados.'
              : 'No saved receipts.',
        ),
      ),
    );
    return;
  }

  final receipts = receiptDirectory
      .listSync()
      .whereType<File>()
      .where(
        (file) =>
            file.path.toLowerCase().endsWith('.jpg') ||
            file.path.toLowerCase().endsWith('.jpeg') ||
            file.path.toLowerCase().endsWith('.png'),
      )
      .toList()
    ..sort(
      (a, b) =>
          b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );

  if (receipts.isEmpty) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No hay recibos guardados.'
              : 'No saved receipts.',
        ),
      ),
    );
    return;
  }

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: const Color(0xFF050B14),
        appBar: AppBar(
          title: Text(
            isSpanish
                ? 'Recibos guardados'
                : 'Saved Receipts',
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: receipts.length,
          itemBuilder: (context, index) {
            final receipt = receipts[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(),
                      body: Center(
                        child: InteractiveViewer(
                          child: Image.file(
                            receipt,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  receipt,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
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
    ? SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 72,
                  color: Colors.white54,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _takeReceiptPhoto,
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                    label: Text(
                      isSpanish
                          ? 'Tomar foto'
                          : 'Take Photo',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed:
                        _chooseReceiptFromLibrary,
                    icon: const Icon(
                      Icons.photo_library_outlined,
                    ),
                    label: Text(
                      isSpanish
                          ? 'Elegir de fotos'
                          : 'Choose From Library',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: _viewSavedReceipts,
    icon: const Icon(
      Icons.receipt_long_outlined,
    ),
    label: Text(
      isSpanish
          ? 'Ver recibos guardados'
          : 'View Saved Receipts',
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
                    TextButton.icon(
  onPressed: _chooseReceiptFromLibrary,
  icon: const Icon(
    Icons.photo_library_outlined,
  ),
  label: Text(
    isSpanish
        ? 'Elegir de fotos'
        : 'Choose From Library',
  ),
),
                  ],
                ),
              ),
            ),
    );
  }
}