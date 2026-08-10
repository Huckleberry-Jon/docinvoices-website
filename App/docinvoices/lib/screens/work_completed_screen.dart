import 'package:flutter/material.dart';
import '../models/labor_item.dart';
import '../models/part_item.dart';
import '../models/job.dart';
import 'customer_invoice_screen.dart';
import '../models/operation.dart';
import 'package:path_provider/path_provider.dart';
import 'scheduled_jobs_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/business_profile_repository.dart';
import '../services/job_repository.dart';

class WorkCompletedScreen extends StatefulWidget {
  const WorkCompletedScreen({
    super.key,
    required this.job,
    required this.languageCode,
  });

  final Job job;
  final String languageCode;
  

  @override
  State<WorkCompletedScreen> createState() =>
      _WorkCompletedScreenState();
}

class _WorkCompletedScreenState extends State<WorkCompletedScreen> {
  @override
void initState() {
  super.initState();

  if (widget.job.invoiceNumber.trim().isEmpty) {
    widget.job.invoiceNumber =
        JobRepository.instance.nextInvoiceNumber();

    JobRepository.instance.updateJob(widget.job);
  }
}
  bool get isSpanish => widget.languageCode == 'es';
  bool showServiceDetails = false;
 final List<LaborItem> laborItems = [];
 final List<PartItem> partItems = [];
 final ImagePicker _imagePicker = ImagePicker();

Future<ImageSource?> _choosePhotoSource() {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
              ),
              title: Text(
                isSpanish
                    ? 'Tomar foto'
                    : 'Take Photo',
              ),
              onTap: () {
                Navigator.pop(
                  sheetContext,
                  ImageSource.camera,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
              ),
              title: Text(
                isSpanish
                    ? 'Elegir de la biblioteca'
                    : 'Choose from Photo Library',
              ),
              onTap: () {
                Navigator.pop(
                  sheetContext,
                  ImageSource.gallery,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _addJobPhoto({
  required bool isBefore,
}) async {
  final source = await _choosePhotoSource();

  if (source == null) {
    return;
  }

  final photo = await _imagePicker.pickImage(
    source: source,
    imageQuality: 80,
  );

  if (photo == null) {
    return;
  }

  final appDirectory =
      await getApplicationDocumentsDirectory();

  final photoDirectory = Directory(
    '${appDirectory.path}/job_photos',
  );

  if (!await photoDirectory.exists()) {
    await photoDirectory.create(recursive: true);
  }

  final lastSlash = photo.path.lastIndexOf('/');
  final lastDot = photo.path.lastIndexOf('.');

  final extension =
      lastDot > lastSlash ? photo.path.substring(lastDot) : '.jpg';

  final photoType = isBefore ? 'before' : 'after';

  final savedPath =
      '${photoDirectory.path}/'
      '${photoType}_${DateTime.now().microsecondsSinceEpoch}'
      '$extension';

  await File(photo.path).copy(savedPath);

  if (!mounted) {
    return;
  }

  setState(() {
    if (isBefore) {
      widget.job.beforePhotoPaths.add(savedPath);
    } else {
      widget.job.afterPhotoPaths.add(savedPath);
    }
  });

  JobRepository.instance.updateJob(widget.job);
  await JobRepository.instance.save();
}

Future<void> _takeBeforePhoto() {
  return _addJobPhoto(isBefore: true);
}

Future<void> _takeAfterPhoto() {
  return _addJobPhoto(isBefore: false);
}
 double salesTaxRate = 0.0825;
 double get taxablePartsTotal {
  return partItems
      .where((item) => item.taxable)
      .fold(
        0.0,
        (total, item) => total + item.total,
      );
}

double get salesTax {
  return taxablePartsTotal * salesTaxRate;
}
 double get partsTotal {
  return partItems.fold(
    0.0,
    (total, item) => total + item.total,
  );
}

double get laborTotal {
  return laborItems.fold(
    0.0,
    (total, item) => total + item.total,
  );
}
double get jobLaborTotal {
  return widget.job.operations.fold(
    0.0,
    (total, operation) => total + operation.laborTotal,
  );
}

double get jobPartsTotal {
  return widget.job.operations.fold(
    0.0,
    (total, operation) => total + operation.partsTotal,
  );
}

double get generalChargesTotal {
  return widget.job.generalCharges.fold(
    0.0,
    (total, charge) => total + charge.amount,
  );
}
double get jobTaxablePartsTotal {
  return widget.job.operations.fold(
    0.0,
    (total, operation) =>
        total +
        operation.parts
            .where((part) => part.taxable)
            .fold(
              0.0,
              (partTotal, part) =>
                  partTotal + part.total,
            ),
  );
}

double get jobSalesTax {
  return jobTaxablePartsTotal * salesTaxRate;
}
double get finalJobTotal {
  return jobLaborTotal +
      jobPartsTotal +
      generalChargesTotal +
      jobSalesTax -
      widget.job.discountAmount;
}
 
 void _showAddLaborDialog() {
  final descriptionController = TextEditingController();
  final hoursController = TextEditingController();
  final rateController = TextEditingController();
  

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
  isSpanish ? 'Agregar mano de obra' : 'Add Labor',
),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration:  InputDecoration(
                  labelText: isSpanish ? 'Descripción' : 'Description',
hintText: isSpanish
    ? 'Ejemplo: Reparación de frenos'
    : 'Example: Brake repair',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hoursController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: isSpanish ? 'Horas' : 'Hours',
hintText: isSpanish
    ? 'Ejemplo: 2.5'
    : 'Example: 2.5',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rateController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:  InputDecoration(
                 labelText: isSpanish ? 'Tarifa por hora' : 'Hourly Rate',
hintText: isSpanish
    ? 'Ejemplo: 125.00'
    : 'Example: 125.00',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
  isSpanish ? 'Cancelar' : 'Cancel',
),
          ),
          ElevatedButton(
            onPressed: () {
              final description = descriptionController.text.trim();
              final hours = double.tryParse(hoursController.text.trim());
              final rate = double.tryParse(rateController.text.trim());

              if (description.isEmpty || hours == null || rate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(
                    content: Text(
                      isSpanish
    ? 'Ingrese una descripción, las horas y la tarifa por hora.'
    : 'Enter a description, hours, and hourly rate.',
                    ),
                  ),
                );
                return;
              }

           setState(() {
  laborItems.add(
    LaborItem(
      description: description,
      hours: hours,
      rate: rate,
    ),
  );
});

Navigator.pop(dialogContext);
},
child: Text(
  isSpanish ? 'Guardar mano de obra' : 'Save Labor',
),
),
],
);
},
);
}
void _showAddPartDialog() {
  final descriptionController = TextEditingController();
final quantityController = TextEditingController();
final unitPriceController = TextEditingController();

 bool taxable = true;
double selectedMarkup =
    BusinessProfileRepository.instance.profile.partsMarkupPercent;

double tierForCost(double cost) {
  if (cost >= 1500) {
    return 10;
  }

  if (cost >= 500) {
    return 20;
  }

  return 30;
}
  showDialog(
    context: context,
    builder: (dialogContext) {
  return StatefulBuilder(
    builder: (context, setDialogState) {
      return AlertDialog(
        title: Text(
  isSpanish ? 'Agregar pieza' : 'Add Part',
),
        content: SizedBox(
  width: 420,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const SizedBox(height: 12),

CheckboxListTile(
  contentPadding: EdgeInsets.zero,
  title: Text(
  isSpanish ? 'Sujeto a impuestos' : 'Taxable',
),
  value: taxable,
  onChanged: (value) {
    setDialogState(() {
      taxable = value ?? true;
    });
  },
),
      TextField(
         controller: descriptionController,
        decoration: InputDecoration(
          labelText: isSpanish ? 'Descripción' : 'Description',
hintText: isSpanish
    ? 'Ejemplo: Filtro de aire'
    : 'Example: Air Filter',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
     TextField(
  controller: quantityController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
        decoration:  InputDecoration(
          labelText: isSpanish ? 'Cantidad' : 'Quantity',
hintText: isSpanish
    ? 'Ejemplo: 2'
    : 'Example: 2',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 16),
     TextField(
  controller: unitPriceController,
  keyboardType:
      const TextInputType.numberWithOptions(
    decimal: true,
  ),
  onChanged: (value) {
    final cost =
        double.tryParse(value.trim()) ?? 0;

    setDialogState(() {
      selectedMarkup = tierForCost(cost);
    });
  },
  decoration: InputDecoration(
    labelText: isSpanish
        ? 'Costo por unidad'
        : 'Unit Cost',
    hintText: isSpanish
        ? 'Ejemplo: 35.99'
        : 'Example: 35.99',
    prefixText: '\$',
    border: const OutlineInputBorder(),
  ),
),
],
      ),
    ),
        actions: [
          const SizedBox(height: 18),
Align(
  alignment: Alignment.centerLeft,
  child: Text(
    isSpanish
        ? 'Margen de pieza'
        : 'Parts Markup',
    style: const TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
),
const SizedBox(height: 8),
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final markup
        in [10.0, 20.0, 30.0, 0.0])
      ChoiceChip(
        label: Text(
          markup == 0
              ? (isSpanish
                  ? 'Sin margen'
                  : 'No Markup')
              : '${markup.toStringAsFixed(0)}%',
        ),
        selected: selectedMarkup == markup,
        onSelected: (_) {
          setDialogState(() {
            selectedMarkup = markup;
          });
        },
      ),
  ],
),
const SizedBox(height: 12),
Builder(
  builder: (_) {
    final cost = double.tryParse(
          unitPriceController.text.trim(),
        ) ??
        0;

    final customerPrice =
        cost * (1 + selectedMarkup / 100);

    return Text(
      isSpanish
          ? 'Precio al cliente: '
              '\$${customerPrice.toStringAsFixed(2)}'
          : 'Customer Price: '
              '\$${customerPrice.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  },
),
  TextButton(
    onPressed: () => Navigator.pop(dialogContext),
    child: Text(
  isSpanish ? 'Cancelar' : 'Cancel',
),
  ),
  ElevatedButton(
    onPressed: () {
      final description = descriptionController.text.trim();
  final quantity =
      double.tryParse(quantityController.text.trim());
  final unitCost =
    double.tryParse(unitPriceController.text.trim());

  if (description.isEmpty ||
      quantity == null ||
      unitCost == null) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(
          isSpanish
    ? 'Ingrese una descripción, la cantidad y el costo unitario.'
    : 'Enter a description, quantity, and unit cost.',
        ),
      ),
    );
    return;
  }
final customerPrice =
    unitCost * (1 + selectedMarkup / 100);
  setState(() {
  final newPart = PartItem(
  description: description,
  quantity: quantity,
  unitCost: unitCost,
  markupPercent: selectedMarkup,
  unitPrice: customerPrice,
  taxable: taxable,
);

  if (widget.job.operations.isEmpty) {
    widget.job.operations.add(
      Operation(
        title: isSpanish ? 'Trabajo revisado' : 'Reviewed Work',
        labor: [],
        parts: [newPart],
        notes: widget.job.transcription,
      ),
    );
  } else {
    widget.job.operations.first.parts.add(newPart);
  }
});

  Navigator.pop(dialogContext);
         },
    child: Text(
  isSpanish ? 'Guardar pieza' : 'Save Part',
),
  ),
],
      );
    },
  );
 },
);
}
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1624),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? Colors.white12,
        ),
      ),
      child: child,
    );
  }

  Widget _detailRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow({
    required String label,
    required String amount,
    bool total = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: total ? Colors.white : Colors.white70,
                fontSize: total ? 21 : 17,
                fontWeight:
                    total ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color:
                  total ? Colors.orangeAccent : Colors.white,
              fontSize: total ? 30 : 17,
              fontWeight:
                  total ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }


  Widget _photoPlaceholder({
  required String label,
  required IconData icon,
  required VoidCallback onTap,
}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 145,
          decoration: BoxDecoration(
            color: const Color(0xFF07111D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.blue,
                size: 44,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isSpanish ? 'Toque para ver' : 'Tap to view',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                       Expanded(
                        child: Column(
                          children: [
                            Text(
                              isSpanish ? 'Trabajo completado' : 'Work Completed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                               isSpanish ? 'Número de factura' : 'Invoice Number',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
const SizedBox(height: 4),

Text(
  widget.job.invoiceNumber,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
Text(
  widget.job.invoiceNumber.trim().isEmpty
      ? '--'
      : widget.job.invoiceNumber,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
  final profile =
      BusinessProfileRepository.instance.profile;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        isSpanish
            ? '¿Necesita ayuda?'
            : 'Need Help?',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSpanish
                ? 'Comuníquese con nosotros si tiene alguna pregunta sobre su reparación.'
                : 'Contact us if you have any questions about your repair.',
          ),
          const SizedBox(height: 16),
          if (profile.businessName.isNotEmpty)
            Text(profile.businessName),
          if (profile.phone.isNotEmpty)
            Text(profile.phone),
          if (profile.email.isNotEmpty)
            Text(profile.email),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            isSpanish ? 'Cerrar' : 'Close',
          ),
        ),
      ],
    ),
  );
},
                        icon: const Icon(
                          Icons.help_outline,
                          color: Colors.white70,
                          size: 28,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _card(
                    borderColor:
                        Colors.greenAccent.withValues(alpha: 0.40),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent,
                          size: 42,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSpanish
    ? 'Su reparación está completa'
    : 'Your repair is complete',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                isSpanish
    ? 'Gracias por elegir nuestros servicios. Revise el trabajo completado y los detalles de respaldo a continuación.'
    : 'Thank you for choosing our services. Review the completed work and supporting details below.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blue,
                              size: 29,
                            ),
                            SizedBox(width: 11),
                            Text(
                              isSpanish ? 'Información del trabajo' : 'Job Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _detailRow(
                           label: isSpanish ? 'Cliente' : 'Customer',
                          value: widget.job.customerName,
                        ),
                        _detailRow(
                           label: isSpanish ? 'Equipo' : 'Equipment',
                          value: widget.job.equipment,
                        ),
                        _detailRow(
                           label: isSpanish ? 'Unidad #' : 'Unit #',
                          value: widget.job.unitNumber,
                        ),
                        _detailRow(
                          label: isSpanish ? 'VIN / Número de serie' : 'VIN / Serial Number',
                          value: widget.job.vin,
                        ),
                        _detailRow(
  label: isSpanish ? 'Kilometraje' : 'Mileage',
  value: widget.job.mileage,
                        ),
                        _detailRow(
  label: isSpanish ? 'Número de OC' : 'PO Number',
  value: widget.job.poNumber,
),

_detailRow(
  label: isSpanish ? 'Completado' : 'Completed',
  value: widget.job.completedDate,
),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            setState(() {
                              showServiceDetails =
                                  !showServiceDetails;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.build_circle_outlined,
                                  color: Colors.blue,
                                  size: 31,
                                ),
                                const SizedBox(width: 12),
                                 Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSpanish ? 'Servicios completados' : 'Services Completed',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.job.transcription.trim().isEmpty &&
    widget.job.operations.isEmpty
                                        ? (isSpanish
    ? 'No hay detalles del servicio'
    : 'No service details')
: (isSpanish
    ? 'Detalles del servicio completado'
    : 'Completed service details'),
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  showServiceDetails
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.blue,
                                  size: 34,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (showServiceDetails) ...[
  const Divider(
    color: Colors.white12,
    height: 30,
  ),

  if (widget.job.operations.isNotEmpty)
    ...widget.job.operations.map(
      (operation) => _serviceItem(
        [
          operation.title,
          operation.repairDescription,
          operation.notes,
        ]
            .map((value) => value.toString().trim())
            .where((value) => value.isNotEmpty)
            .join('\n\n'),
      ),
    ),

  if (widget.job.transcription.trim().isNotEmpty)
    _serviceItem(
      widget.job.transcription.trim(),
    ),

  if (widget.job.operations.isEmpty &&
      widget.job.transcription.trim().isEmpty)
    _serviceItem(
      isSpanish
          ? 'No se ingresaron detalles del trabajo.'
          : 'No work details entered.',
    ),
],
                      ]
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.blue,
                              size: 30,
                            ),
                            SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isSpanish ? 'Prueba del trabajo' : 'Proof of Work',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
  isSpanish
      ? '${widget.job.beforePhotoPaths.length + widget.job.afterPhotoPaths.length} fotos incluidas'
      : '${widget.job.beforePhotoPaths.length + widget.job.afterPhotoPaths.length} photos included',
  style: const TextStyle(
    color: Colors.white60,
    fontSize: 15,
  ),
),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _photoPlaceholder(
  label: isSpanish ? 'Antes' : 'Before',
  icon: Icons.image_outlined,
  onTap: _takeBeforePhoto,
),
                            const SizedBox(width: 14),
                            _photoPlaceholder(
  label: isSpanish ? 'Después' : 'After',
  icon: Icons.auto_awesome,
  onTap: _takeAfterPhoto,
),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
  final allPhotoPaths = [
    ...widget.job.beforePhotoPaths,
    ...widget.job.afterPhotoPaths,
  ];

  if (allPhotoPaths.isEmpty) {
    _showMessage(
      isSpanish
          ? 'Aún no se han agregado fotos.'
          : 'No photos have been added yet.',
    );
    return;
  }

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        child: SizedBox(
          width: 700,
          height: 520,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isSpanish
                            ? 'Fotos del trabajo'
                            : 'Work Photos',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: allPhotoPaths.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(
                        File(allPhotoPaths[index]),
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
},
icon: const Icon(
  Icons.collections_outlined,
),
label: Text(
  isSpanish
      ? 'Ver todas las fotos'
      : 'View All Photos',
  style: const TextStyle(
    fontSize: 16,
  ),
),
 ),
                        ),

                  const SizedBox(height: 16),

                  _card(
                    borderColor:
                        Colors.greenAccent.withValues(alpha: 0.30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: Colors.greenAccent,
                          size: 36,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Approved',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                               isSpanish
    ? 'Aprobación del cliente registrada'
    : 'Customer approval recorded',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                isSpanish
    ? 'Los detalles de la aprobación estarán disponibles en una actualización futura.'
    : 'Approval details will be available in a future update.',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                   ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.orange,
                              size: 31,
                            ),
                            SizedBox(width: 11),
                            Text(
                              isSpanish ? 'Resumen de la factura' : 'Invoice Summary',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: _showAddLaborDialog,
    icon: const Icon(Icons.engineering),
    label:  Text(
      isSpanish ? 'Agregar mano de obra' : 'Add Labor',
      style: TextStyle(fontSize: 17),
    ),
  ),
),
const SizedBox(height: 10),

SizedBox(
  width: double.infinity,
  child: OutlinedButton.icon(
    onPressed: _showAddPartDialog,
    icon: const Icon(Icons.inventory_2_outlined),
    label:  Text(
      isSpanish ? 'Agregar pieza' : 'Add Part',
      style: TextStyle(fontSize: 17),
    ),
  ),
),

const SizedBox(height: 18),
if (widget.job.operations.isEmpty)
  _priceRow(
    label: isSpanish ? 'Mano de obra' : 'Labor',
amount: isSpanish ? 'No ingresado' : 'Not entered',
  )
else ...[
  for (final operation in widget.job.operations)
  for (final item in operation.labor) ...[
    _detailRow(
      label: item.description,
      value:
          '${item.hours.toStringAsFixed(2)} hrs × '
          '\$${item.rate.toStringAsFixed(2)}',
    ),
    _priceRow(
      label: isSpanish ? 'Total de la línea' : 'Line Total',
      amount: '\$${item.total.toStringAsFixed(2)}',
    ),
    const Divider(
      color: Colors.white12,
      height: 20,
    ),
  ],
  _priceRow(
    label: isSpanish ? 'Total de mano de obra' : 'Labor Total',
    amount: '\$${jobLaborTotal.toStringAsFixed(2)}',
  ),
],
if (widget.job.operations.isEmpty)
  _priceRow(
    label: isSpanish ? 'Piezas' : 'Parts',
amount: isSpanish ? 'No ingresado' : 'Not entered',
  )
else ...[
  for (final operation in widget.job.operations)
  for (final item in operation.parts) ...[
    _detailRow(
      label: item.description,
      value:
          '${item.quantity.toStringAsFixed(2)} × '
          '\$${item.unitPrice.toStringAsFixed(2)}',
    ),
    _priceRow(
      label: isSpanish ? 'Total de la línea' : 'Line Total',
      amount: '\$${item.total.toStringAsFixed(2)}',
    ),
    const Divider(
      color: Colors.white12,
      height: 20,
    ),
  ],
  _priceRow(
    label:isSpanish ? 'Total de piezas' : 'Parts Total',
    amount: '\$${jobPartsTotal.toStringAsFixed(2)}',
    
  ),
  ...widget.job.generalCharges.map(
  (charge) => _priceRow(
    label: charge.description,
    amount: '\$${charge.amount.toStringAsFixed(2)}',
  ),
),
],
_priceRow(
  label: isSpanish ? 'Impuesto sobre ventas' : 'Sales Tax',
  amount: '\$${jobSalesTax.toStringAsFixed(2)}',
),
const Divider(
  color: Colors.white24,
  height: 30,
),
_priceRow(
  label: 'TOTAL',
  amount: finalJobTotal > 0
      ? '\$${finalJobTotal.toStringAsFixed(2)}'
      : isSpanish
          ? 'Pendiente'
          : 'Pending',
  total: true,
),
                        const SizedBox(height: 8),
                         Text(
                          isSpanish
    ? 'El trabajo, las fotos y la aprobación anteriores proporcionan la documentación que respalda este total.'
    : 'The work, photos, and approval above provide documentation supporting this total.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),


                  const SizedBox(height: 20),

                 SizedBox(
  height: 72,
  child: ElevatedButton(
    onPressed: () {
      widget.job.estimatedTotal =
          finalJobTotal.toStringAsFixed(2);
if (widget.job.invoiceNumber.trim().isEmpty) {
  widget.job.invoiceNumber =
      JobRepository.instance.nextInvoiceNumber();

  widget.job.jobStatus = 'Invoiced';

  JobRepository.instance.updateJob(
    widget.job,
  );
}
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerInvoiceScreen(
            languageCode: widget.languageCode,
            job: widget.job,
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSpanish
              ? 'Continuar a la factura'
              : 'Continue to Invoice',
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          isSpanish
              ? 'Total de la factura'
              : 'Invoice Total',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  ),
),

                  const SizedBox(height: 18),

                  _card(
                    child: Column(
                      children: [
                         Text(
                          isSpanish
    ? '¿Tiene preguntas o necesita servicio nuevamente?'
    : 'Questions or need service again?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
  final profile =
      BusinessProfileRepository.instance.profile;

  if (profile.phone.trim().isEmpty) {
    _showMessage(
      isSpanish
          ? 'No hay un número de teléfono comercial guardado.'
          : 'No business phone number has been saved.',
    );
    return;
  }

  final uri = Uri(
    scheme: 'tel',
    path: profile.phone,
  );

  await launchUrl(uri);
},
                                icon: const Icon(
                                  Icons.phone_outlined,
                                ),
                                label: Text(
  isSpanish ? 'Llamar al negocio' : 'Call Business',
),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                               onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ScheduledJobsScreen(
        languageCode: widget.languageCode,
             ),
    ),
  );
},
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                ),
                                label:
                                    Text(
  isSpanish ? 'Programar servicio' : 'Schedule Service',
),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    isSpanish
    ? 'Creado con DocInvoices'
    : 'Created with DocInvoices',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}