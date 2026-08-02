import 'package:flutter/material.dart';
import '../models/labor_item.dart';
import '../models/part_item.dart';
import 'payment_received_screen.dart';
import '../models/job.dart';

import 'pdf_preview_screen.dart';
import '../models/payment.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../services/business_profile_repository.dart';
import 'notifications_screen.dart';
class CustomerInvoiceScreen extends StatefulWidget {
  const CustomerInvoiceScreen({
    super.key,
    required this.languageCode,
    required this.job,
  });

  final String languageCode;
  final Job job;
  String get transcription => job.transcription;
String get customerName => job.customerName;
String get equipment => job.equipment;
String get unitNumber => job.unitNumber;
String get vin => job.vin;
String get mileage => job.mileage;
String get poNumber => job.poNumber;
String get completedDate => job.completedDate;
String get estimatedTotal => job.estimatedTotal;


List<LaborItem> get laborItems =>
    job.operations.expand((operation) => operation.labor).toList();

List<PartItem> get partItems =>
    job.operations.expand((operation) => operation.parts).toList();

double get laborTotal =>
    job.operations.fold(0.0, (sum, operation) => sum + operation.laborTotal);

double get partsTotal =>
    job.operations.fold(0.0, (sum, operation) => sum + operation.partsTotal);

double get generalChargesTotal =>
    job.generalCharges.fold(0.0, (sum, charge) => sum + charge.amount);

double get taxablePartsTotal =>
    partItems
        .where((item) => item.taxable)
        .fold(0.0, (sum, item) => sum + item.total);

double get taxableGeneralChargesTotal =>
    job.generalCharges
        .where((charge) => charge.taxable)
        .fold(0.0, (sum, charge) => sum + charge.amount);

double get salesTax {
  const double salesTaxRate = 0.0825;

  return (taxablePartsTotal + taxableGeneralChargesTotal) *
      salesTaxRate;
}
double get invoiceTotal =>
    laborTotal +
    partsTotal +
    generalChargesTotal +
    salesTax -
    job.discountAmount;

  @override
  State<CustomerInvoiceScreen> createState() =>
      _CustomerInvoiceScreenState();
     
}

class _CustomerInvoiceScreenState
    extends State<CustomerInvoiceScreen> {
      String? selectedPaymentMethod;
      final paymentAmountController = TextEditingController();
      
  bool get isSpanish => widget.languageCode == 'es';
  bool showServiceDetails = false;
  
  void _showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
  Job get job => widget.job;

String get transcription => job.transcription;
String get customerName => job.customerName;
String get equipment => job.equipment;
String get unitNumber => job.unitNumber;
String get vin => job.vin;
String get mileage => job.mileage;
String get poNumber => job.poNumber;
String get completedDate => job.completedDate;
String get estimatedTotal => job.estimatedTotal;
final paymentDetailController = TextEditingController();
@override
void initState() {
  super.initState();

  paymentAmountController.text =
      widget.job.balanceDue > 0
          ? widget.job.balanceDue.toStringAsFixed(2)
          : widget.invoiceTotal.toStringAsFixed(2);
}
@override
void dispose() {
  paymentDetailController.dispose();
  paymentAmountController.dispose();
  super.dispose();
}
  void _completePayment() {
  final String paymentDetail =
    paymentDetailController.text.trim();

final double? paymentAmount =
    double.tryParse(paymentAmountController.text.trim());

if (paymentAmount == null || paymentAmount <= 0) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSpanish
            ? 'Ingrese un monto de pago válido.'
            : 'Enter a valid payment amount.',
      ),
    ),
  );
  return;
}

if (selectedPaymentMethod == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSpanish
            ? 'Seleccione un método de pago.'
            : 'Select a payment method.',
      ),
    ),
  );
  return;
}
  if (selectedPaymentMethod == 'Cash') {
    final double? amountReceived =
        double.tryParse(
  paymentDetailController.text.trim(),
);

    if (amountReceived == null ||
        amountReceived < paymentAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSpanish
                ? 'Ingrese un monto recibido válido.'
                : 'Enter a valid amount received.',
          ),
        ),
      );
      return;
    }
  }

  if (selectedPaymentMethod == 'Check' &&
      paymentDetail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'Ingrese el número de cheque.'
              : 'Enter the check number.',
        ),
      ),
    );
    return;
  }

  if (selectedPaymentMethod == 'Other' &&
      paymentDetail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'Ingrese una descripción del pago.'
              : 'Enter a payment description.',
        ),
      ),
    );
    return;
  }
widget.job.payments.add(
  Payment(
    method: selectedPaymentMethod!,
    amount: paymentAmount,
    reference: paymentDetailController.text.trim(),
  ),
);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentReceivedScreen(
        languageCode: widget.languageCode,
        job: widget.job,
      ),
    ),
  );
}

  Widget _card({
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              color: total ? Colors.orangeAccent : Colors.white,
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
        onTap: () {
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

  Widget _progressItem({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoBox({
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
Widget _paymentSummaryRow({
  required String label,
  required double amount,
  bool bold = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? Colors.white : Colors.white70,
              fontSize: bold ? 18 : 16,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: bold ? Colors.orange : Colors.white,
            fontSize: bold ? 20 : 16,
            fontWeight:
                bold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final profile = BusinessProfileRepository.instance.profile;
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
                              isSpanish ? 'Factura del cliente' : 'Customer Invoice',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.job.invoiceNumber.trim().isEmpty
    ? (isSpanish ? 'Factura pendiente' : 'Invoice Pending')
    : '${isSpanish ? 'Factura' : 'Invoice'} #${widget.job.invoiceNumber}',
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
                  _card(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF101D2C),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.65),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: profile.logoPath.trim().isEmpty
            ? const Icon(
                Icons.business_outlined,
                color: Colors.white54,
                size: 38,
              )
            : Image.file(
                File(profile.logoPath),
                fit: BoxFit.cover,
              ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.businessName.trim().isEmpty
                  ? 'DocInvoices'
                  : profile.businessName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (profile.tagline.trim().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                profile.tagline,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),
            ],
            if (profile.phone.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                profile.phone,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            ],
            if (profile.email.trim().isNotEmpty)
              Text(
                profile.email,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
            if (profile.fullAddress.trim().isNotEmpty)
              Text(
                profile.fullAddress,
                style: const TextStyle(
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

const SizedBox(height: 18),
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
    ? 'Gracias por elegir nuestros servicios.'
    : 'Thank you for choosing our services.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                isSpanish
    ? 'Revise el trabajo completado y los detalles de respaldo antes de completar el pago.'
    : 'Review the completed work and supporting details before completing payment.',
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
                              Icons.task_alt,
                              color: Colors.greenAccent,
                              size: 30,
                            ),
                            SizedBox(width: 11),
                            Text(
                              isSpanish ? 'Progreso del trabajo' : 'Job Progress',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _progressItem(
                          text: isSpanish ? 'Diagnóstico completado' : 'Diagnosis completed',
                        ),
                        _progressItem(
                           text: isSpanish ? 'Reparación completada' : 'Repair completed',
                        ),
                        _progressItem(
                          text: isSpanish ? 'Control de calidad aprobado' : 'Quality check passed',
                        ),
                        _progressItem(
                           text: isSpanish
      ? 'Aprobación del cliente recibida'
      : 'Customer approval received',
                        ),
                        _progressItem(
                          text: isSpanish ? 'Listo para el pago' : 'Ready for payment',
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
                          value: widget.customerName,
                        ),
                        _detailRow(
                          label: isSpanish ? 'Equipo' : 'Equipment',
                          value: widget.equipment,
                        ),
                        _detailRow(
                          label: isSpanish ? 'Unidad #' : 'Unit #',
                          value: widget.unitNumber,
                        ),
                        _detailRow(
                          label: isSpanish ? 'VIN / Número de serie' : 'VIN / Serial Number',
                          value: widget.vin,
                        ),
                        _detailRow(
                          label: isSpanish ? 'Kilometraje' : 'Mileage',
                          value: widget.mileage,
                        ),
                        _detailRow(
                          label: isSpanish ? 'Número de OC' : 'PO Number',
                          value:  widget.poNumber,
                        ),
                        _detailRow(
                          label: isSpanish ? 'Completado' : 'Completed',
                          value: widget.completedDate,
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
  isSpanish
      ? '${widget.job.operations.length} ${widget.job.operations.length == 1 ? 'servicio completado' : 'servicios completados'}'
      : '${widget.job.operations.length} ${widget.job.operations.length == 1 ? 'completed service' : 'completed services'}',
  style: const TextStyle(
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
    widget.transcription,
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
                            _photoBox(
                              label: isSpanish ? 'Antes' : 'Before',
                              icon: Icons.image_outlined,
                            ),
                            const SizedBox(width: 14),
                            _photoBox(
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
                    child:  Row(
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
                                isSpanish ? 'Aprobación del cliente' : 'Customer Approval',
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
                        const SizedBox(height: 17),
 if (widget.laborItems.isEmpty)
  _priceRow(
  label: isSpanish ? 'Total de mano de obra' : 'Labor Total',
  amount: '\$${widget.laborItems.fold(
    0.0,
    (total, item) => total + item.total,
  ).toStringAsFixed(2)}',
)
else ...[
  _priceRow(
  label: isSpanish ? 'Total de mano de obra' : 'Labor Total',
  amount: '\$${widget.laborItems.fold(
    0.0,
    (total, item) => total + item.total,
  ).toStringAsFixed(2)}',
),
  for (final item in widget.laborItems) ...[
    _detailRow(
      label: item.description,
      value:
          '${item.hours.toStringAsFixed(2)} hrs × '
          '\$${item.rate.toStringAsFixed(2)}',
    ),
    _priceRow(
      label: 'Line Total',
      amount: '\$${item.total.toStringAsFixed(2)}',
    ),
    const Divider(
      color: Colors.white12,
      height: 20,
    ),
  ],
],

if (widget.partItems.isEmpty)
 _priceRow(
  label: isSpanish ? 'Total de piezas' : 'Parts Total',
  amount: '\$${widget.partItems.fold(
    0.0,
    (total, item) => total + item.total,
  ).toStringAsFixed(2)}',
)
else ...[
  for (final item in widget.partItems) ...[
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
    label: isSpanish ? 'Total de piezas' : 'Parts Total',
    amount: '\$${widget.partItems.fold(
      0.0,
      (total, item) => total + item.total,
    ).toStringAsFixed(2)}',
  ),
],

_priceRow(
  label: isSpanish ? 'Impuesto sobre ventas' : 'Sales Tax',
  amount: '\$${widget.salesTax.toStringAsFixed(2)}',
),
const Divider(
  color: Colors.white24,
  height: 30,
),
_priceRow(
  label: 'TOTAL',
  amount: '\$${widget.invoiceTotal.toStringAsFixed(2)}',
  total: true,
),
                        const SizedBox(height: 8),
                        Text(
                          isSpanish
    ? 'El trabajo completado, las fotos de evidencia y la aprobación del cliente mostrados arriba respaldan este total.'
    : 'The completed work, proof photos, and customer approval above support this total.',
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
                        label: isSpanish ? 'Correo electrónico' : 'Email',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        icon: Icons.sms_outlined,
                        label: isSpanish ? 'Mensaje de texto' : 'Text',
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
                        icon: Icons.link,
  label: isSpanish ? 'Enlace seguro' : 'Secure Link',
  color: Colors.purpleAccent,
                      ),
                    ],
                  ),
                  _card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        isSpanish
            ? 'Método de pago'
            : 'Payment Method',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final method in [
            'Cash',
            'Card',
            'Check',
            'ACH',
            'Other',
          ])
            ChoiceChip(
              label: Text(
                isSpanish
                    ? {
                        'Cash': 'Efectivo',
                        'Card': 'Tarjeta',
                        'Check': 'Cheque',
                        'ACH': 'ACH',
                        'Other': 'Otro',
                      }[method]!
                    : method,
              ),
              selected: selectedPaymentMethod == method,
              onSelected: (selected) {
                setState(() {
                  selectedPaymentMethod =
                      selected ? method : null;
                });
              },
            ),
        ],
      ),
    ],
  ),
),
const SizedBox(height: 16),

_card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _paymentSummaryRow(
        label: isSpanish
            ? 'Total de la factura'
            : 'Invoice Total',
        amount: widget.invoiceTotal,
      ),
      _paymentSummaryRow(
        label: isSpanish
            ? 'Pagado'
            : 'Already Paid',
        amount: widget.job.totalPaid,
      ),
      _paymentSummaryRow(
        label: isSpanish
            ? 'Saldo pendiente'
            : 'Balance Due',
        amount: widget.job.balanceDue,
        bold: true,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: paymentAmountController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: isSpanish
              ? 'Monto del pago'
              : 'Payment Amount',
          prefixText: '\$',
          border: const OutlineInputBorder(),
        ),
      ),
    ],
  ),
),

                   SizedBox(height: 20),
                  SizedBox(
                    height: 76,
                    child: ElevatedButton(
                      onPressed:
                   selectedPaymentMethod == null ? null : _completePayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSpanish ? 'Completar pago' : 'Complete Payment',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
  isSpanish
      ? 'Total: \$${widget.invoiceTotal.toStringAsFixed(2)}'
      : 'Invoice Total: \$${widget.invoiceTotal.toStringAsFixed(2)}',
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
),
if (selectedPaymentMethod != null) ...[
  const SizedBox(height: 16),

  TextField(
    controller: paymentDetailController,
    keyboardType: selectedPaymentMethod == 'Cash'
        ? const TextInputType.numberWithOptions(
            decimal: true,
          )
        : TextInputType.text,
    decoration: InputDecoration(
      labelText: selectedPaymentMethod == 'Cash'
          ? (isSpanish
              ? 'Monto recibido'
              : 'Amount Received')
          : selectedPaymentMethod == 'Card'
              ? (isSpanish
                  ? 'Número de autorización'
                  : 'Authorization Number')
              : selectedPaymentMethod == 'Check'
                  ? (isSpanish
                      ? 'Número de cheque'
                      : 'Check Number')
                  : selectedPaymentMethod == 'ACH'
                      ? (isSpanish
                          ? 'Número de confirmación'
                          : 'Confirmation Number')
                      : (isSpanish
                          ? 'Nota del pago'
                          : 'Payment Memo'),
      border: const OutlineInputBorder(),
    ),
  ),
],
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
                                label:  Text(isSpanish ? 'Llamar al negocio' : 'Call Business',),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NotificationsScreen(
        languageCode: widget.languageCode,
      ),
    ),
  );
},
icon: const Icon(
  Icons.notifications_active_outlined,
),
label: Text(
  isSpanish
      ? 'Crear recordatorio'
      : 'Create Reminder',
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
    ? 'Gracias por su preferencia.'
    : 'Thank you for your business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
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