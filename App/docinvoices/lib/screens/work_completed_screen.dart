import 'package:flutter/material.dart';
import '../models/labor_item.dart';
import '../models/part_item.dart';
import '../models/job.dart';
import 'customer_invoice_screen.dart';
import '../models/operation.dart';
import 'pdf_preview_screen.dart';

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
  bool get isSpanish => widget.languageCode == 'es';
  bool showServiceDetails = false;
 final List<LaborItem> laborItems = [];
 final List<PartItem> partItems = [];
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

double get finalJobTotal {
  return jobLaborTotal +
      jobPartsTotal +
      generalChargesTotal +
      salesTax;
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
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
        decoration: InputDecoration(
          labelText: isSpanish ? 'Precio unitario' : 'Unit Price',
hintText: isSpanish
    ? 'Ejemplo: 35.99'
    : 'Example: 35.99',
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
  final quantity =
      double.tryParse(quantityController.text.trim());
  final unitPrice =
      double.tryParse(unitPriceController.text.trim());

  if (description.isEmpty ||
      quantity == null ||
      unitPrice == null) {
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(
          isSpanish
    ? 'Ingrese una descripción, la cantidad y el precio unitario.'
    : 'Enter a description, quantity, and unit price.',
        ),
      ),
    );
    return;
  }

  setState(() {
  final newPart = PartItem(
    description: description,
    quantity: quantity,
    unitPrice: unitPrice,
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

 Widget _actionButton({
  required IconData icon,
  required String label,
  required Color color,
  VoidCallback? onTap,
}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap ??
    () {
      _showMessage(
        isSpanish
            ? '$label se conectará más adelante.'
            : '$label will be connected later.',
      );
    },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: color.withValues(alpha: 0.55),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 29,
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoPlaceholder({
    required String label,
    required IconData icon,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _showMessage(
  isSpanish
      ? 'El visor de fotos de $label se conectará más adelante.'
      : '$label photo viewer will be connected later.',
);
        },
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
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showMessage(
                            isSpanish
    ? 'La ayuda para clientes se conectará más adelante.'
    : 'Customer help will be connected later.',
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
                                        widget.job.transcription.isEmpty
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
                          _serviceItem(
  widget.job.transcription.isEmpty
      ? (isSpanish
    ? 'No se ingresaron detalles del trabajo.'
    : 'No work details entered.')
      : widget.job.transcription,

                          ),
                        ],
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
                                    isSpanish ? '3 fotos incluidas' : '3 photos included',
                                    style: TextStyle(
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
                            ),
                            const SizedBox(width: 14),
                            _photoPlaceholder(
                              label: isSpanish ? 'Después' : 'After',
                              icon: Icons.auto_awesome,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showMessage(
                                isSpanish
    ? 'La galería de fotos se conectará más adelante.'
    : 'Photo gallery will be connected later.',
                              );
                            },
                            icon: const Icon(
                              Icons.collections_outlined,
                            ),
                            label:  Text(
                              isSpanish ? 'Ver todas las fotos' : 'View All Photos',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
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
if (laborItems.isEmpty)
  _priceRow(
    label: isSpanish ? 'Mano de obra' : 'Labor',
amount: isSpanish ? 'No ingresado' : 'Not entered',
  )
else ...[
  for (final item in laborItems) ...[
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
if (partItems.isEmpty)
  _priceRow(
    label: isSpanish ? 'Piezas' : 'Parts',
amount: isSpanish ? 'No ingresado' : 'Not entered',
  )
else ...[
  for (final item in partItems) ...[
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
  _priceRow(
  label: isSpanish
      ? 'Cargos adicionales'
      : 'Other Charges',
  amount: '\$${generalChargesTotal.toStringAsFixed(2)}',
),
],
_priceRow(
  label: isSpanish ? 'Impuesto sobre ventas' : 'Sales Tax',
  amount: '\$${salesTax.toStringAsFixed(2)}',
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

                  Row(
                    children: [
                      _actionButton(
                        icon: Icons.email_outlined,
                        label: isSpanish ? 'Correo' : 'Email',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        icon: Icons.sms_outlined,
                        label: isSpanish ? 'Texto' : 'Text',
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
  icon: Icons.picture_as_pdf_outlined,
  label: 'PDF',
  color: Colors.redAccent,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewScreen(
          job: widget.job,
        ),
      ),
    );
  },
),
                      const SizedBox(width: 10),
                      _actionButton(
  icon: Icons.share_outlined,
  label: isSpanish ? 'Compartir' : 'Share',
  color: Colors.purpleAccent,
  onTap: () {
    _showMessage(
      isSpanish
          ? 'La función Compartir llegará pronto.'
          : 'Share feature coming soon.',
    );
  },
),
                    ],
                  ),

                  const SizedBox(height: 20),

                 SizedBox(
  height: 72,
  child: ElevatedButton(
    onPressed: () {
      widget.job.estimatedTotal =
          finalJobTotal.toStringAsFixed(2);

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
                                onPressed: () {
                                  _showMessage(
                                    isSpanish
    ? 'La llamada al negocio se conectará más adelante.'
    : 'Calling the business will be connected later.',
                                  );
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
                                  _showMessage(
                                    isSpanish
    ? 'La programación del servicio se conectará más adelante.'
    : 'Scheduling service will be connected later.',
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