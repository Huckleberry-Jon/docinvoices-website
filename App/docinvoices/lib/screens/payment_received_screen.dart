import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../models/job.dart';
import 'dashboard_screen.dart';
import 'package:printing/printing.dart';
import '../services/pdf_service.dart';
import 'package:url_launcher/url_launcher.dart';
class PaymentReceivedScreen extends StatefulWidget {
  const PaymentReceivedScreen({
    super.key,
    required this.languageCode,
    required this.job,
  });

  final String languageCode;
  final Job job;

  String get customerName => job.customerName;
  String get estimatedTotal => job.estimatedTotal;
  String get estimateNumber => job.estimateNumber;
  String get repairOrderNumber => job.repairOrderNumber;
  String get invoiceNumber => job.invoiceNumber;
  String get jobStatus => job.jobStatus;

  @override
  State<PaymentReceivedScreen> createState() =>
      _PaymentReceivedScreenState();
}

class _PaymentReceivedScreenState
    extends State<PaymentReceivedScreen> {
      Payment? get latestPayment {
  if (widget.job.payments.isEmpty) {
    return null;
  }

  return widget.job.payments.last;
}

String get paymentMethod {
  return latestPayment?.method ?? '';
}

String get paymentReference {
  return latestPayment?.reference ?? '';
}
  bool get isSpanish => widget.languageCode == 'es';
  int selectedRating = 0;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _returnToDashboard() {
        Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
  languageCode: widget.languageCode,
),
      ),
      (route) => false,
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
    bool emphasize = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: emphasize
                    ? Colors.white
                    : Colors.white60,
                fontSize: emphasize ? 18 : 16,
                fontWeight: emphasize
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: emphasize ? 25 : 16,
              fontWeight: emphasize
                  ? FontWeight.bold
                  : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryRow({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  VoidCallback? onTap,
}) {
    return Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.14),
              border: Border.all(
                color: color.withValues(alpha: 0.55),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 24,
          ),
        ],
       ),
      ),
    ),
  );
}

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: 58,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(
            label,
            textAlign: TextAlign.center,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(
              color: color,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingStar(int rating) {
    final bool selected = rating <= selectedRating;
    

    return IconButton(
      onPressed: () {
        setState(() {
          selectedRating = rating;
        });

        _showMessage(
          isSpanish
    ? 'Gracias por su calificación de $rating estrellas.'
    : 'Thank you for your $rating-star rating.',
        );
      },
      icon: Icon(
        selected ? Icons.star : Icons.star_border,
        color: selected ? Colors.amber : Colors.white38,
        size: 38,
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
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  Center(
                    child: Container(
                      width: 126,
                      height: 126,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withValues(alpha: 0.15),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 4,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.greenAccent,
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 72,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                   Text(
                    isSpanish ? 'Pago recibido' : 'Payment Received',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                   Text(
  widget.job.isPaidInFull
      ? (isSpanish
          ? 'Factura pagada'
          : 'Invoice Paid')
      : (isSpanish
          ? 'Pago registrado'
          : 'Payment Recorded'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                 Text(
  widget.job.isPaidInFull
      ? (isSpanish
          ? 'La factura fue pagada por completo.'
          : 'The invoice has been paid in full.')
      : (isSpanish
          ? 'El pago fue registrado. Queda un saldo pendiente.'
          : 'The payment was recorded. A balance remains.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _card(
                    borderColor:
                        Colors.greenAccent.withValues(alpha: 0.35),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.greenAccent,
                              size: 31,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isSpanish ? 'Recibo de pago' : 'Payment Receipt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
  widget.job.isPaidInFull
      ? (isSpanish ? 'PAGADO' : 'PAID')
      : (isSpanish ? 'PARCIAL' : 'PARTIAL'),
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                       _detailRow(
  label: isSpanish ? 'Factura' : 'Invoice',
  value: widget.invoiceNumber.isEmpty
      ? (isSpanish ? 'Pendiente' : 'Pending')
      : widget.invoiceNumber,
),
                        _detailRow(
                          label: isSpanish ? 'Cliente' : 'Customer',
  value: widget.customerName,
                        ),
                        _detailRow(
  label: isSpanish ? 'Fecha de pago' : 'Payment Date',
  value: latestPayment == null
      ? (isSpanish ? 'No disponible' : 'Not available')
      : '${latestPayment!.date.month}/'
        '${latestPayment!.date.day}/'
        '${latestPayment!.date.year}',
),
                        _detailRow(
  label: isSpanish ? 'Hora de pago' : 'Payment Time',
  value: latestPayment == null
      ? (isSpanish ? 'No disponible' : 'Not available')
      : '${latestPayment!.date.hour.toString().padLeft(2, '0')}:'
        '${latestPayment!.date.minute.toString().padLeft(2, '0')}',
),
                       _detailRow(
  label: isSpanish ? 'Método de pago' : 'Payment Method',
  value: paymentMethod.isEmpty
      ? (isSpanish ? 'No disponible' : 'Not available')
      : paymentMethod,
),

if (paymentReference.isNotEmpty)
  _detailRow(
    label: isSpanish ? 'Referencia' : 'Reference',
    value: paymentReference,
  ),
                        const Divider(
                          color: Colors.white24,
                          height: 28,
                        ),
                        _detailRow(
  label: isSpanish
      ? 'Pago registrado'
      : 'Payment Recorded',
  value: latestPayment == null
      ? '\$0.00'
      : '\$${latestPayment!.amount.toStringAsFixed(2)}',
  emphasize: true,
  valueColor: Colors.greenAccent,
),
_detailRow(
  label: isSpanish ? 'Total pagado' : 'Total Paid',
  value: '\$${widget.job.totalPaid.toStringAsFixed(2)}',
),

_detailRow(
  label: isSpanish ? 'Saldo pendiente' : 'Balance Due',
  value:
      '\$${widget.job.balanceDue.clamp(0, double.infinity).toStringAsFixed(2)}',
  emphasize: true,
  valueColor: widget.job.isPaidInFull
      ? Colors.greenAccent
      : Colors.orangeAccent,
),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.send_outlined,
                              color: Colors.blue,
                              size: 29,
                            ),
                            SizedBox(width: 11),
                            Text(
                              isSpanish ? 'Recibo entregado' : 'Receipt Delivered',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _deliveryRow(
  icon: Icons.email_outlined,
  title: isSpanish
      ? 'Enviar por correo electrónico'
      : 'Email Receipt',
  subtitle: isSpanish
      ? 'Prepare el recibo para enviarlo por correo electrónico.'
      : 'Prepare the receipt for email delivery.',
  color: Colors.blue,
  onTap: () async {
  final Uri email = Uri(
    scheme: 'mailto',
    queryParameters: {
      'subject': widget.job.invoiceNumber.isEmpty
          ? 'Invoice'
          : 'Invoice ${widget.job.invoiceNumber}',
    },
  );

  await launchUrl(email);
},
),
                       _deliveryRow(
  icon: Icons.sms_outlined,
  title: isSpanish
      ? 'Enviar por mensaje de texto'
      : 'Text Receipt',
  subtitle: isSpanish
      ? 'Prepare el recibo para enviarlo por mensaje de texto.'
      : 'Prepare the receipt for text delivery.',
  color: Colors.greenAccent,
  onTap: () async {
  final Uri sms = Uri(
    scheme: 'sms',
    queryParameters: {
      'body': widget.job.invoiceNumber.isEmpty
          ? 'Your invoice is ready.'
          : 'Your invoice ${widget.job.invoiceNumber} is ready.',
    },
  );

  await launchUrl(sms);
},
),
                        _deliveryRow(
  icon: Icons.picture_as_pdf_outlined,
  title: isSpanish ? 'Compartir factura PDF' : 'Share Invoice PDF',
  subtitle: isSpanish
      ? 'Abra las opciones para compartir la factura.'
      : 'Open sharing options for the invoice.',
  color: Colors.redAccent,
  onTap: () async {
  final bytes = await PdfService.generateInvoice(
    widget.job,
  );

  await Printing.sharePdf(
    bytes: bytes,
    filename:
        '${widget.job.invoiceNumber.isEmpty ? 'Invoice' : widget.job.invoiceNumber}.pdf',
  );
},
),
_deliveryRow(
  icon: Icons.print_outlined,
  title: isSpanish ? 'Imprimir factura' : 'Print Invoice',
  subtitle: isSpanish
      ? 'Abra las opciones de impresión.'
      : 'Open the print options.',
  color: Colors.orange,
  onTap: () async {
    final bytes = await PdfService.generateInvoice(
      widget.job,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: widget.job.invoiceNumber.isEmpty
          ? 'Invoice'
          : widget.job.invoiceNumber,
    );
  },
),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                         Text(
                          isSpanish ? 'Descargar una copia' : 'Download a Copy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _actionButton(
                              icon: Icons.download_outlined,
                              label: 'Receipt',
                              color: Colors.greenAccent,
                              onPressed: () async {
  final bytes = await PdfService.generateInvoice(
    widget.job,
  );

  await Printing.layoutPdf(
    onLayout: (_) async => bytes,
    name: widget.job.invoiceNumber.isEmpty
        ? 'Receipt'
        : 'Receipt-${widget.job.invoiceNumber}',
  );
},
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              icon:
                                  Icons.picture_as_pdf_outlined,
                              label: isSpanish ? 'Factura PDF' : 'Invoice PDF',
                              color: Colors.redAccent,
                              onPressed: () async {
  final bytes = await PdfService.generateInvoice(
    widget.job,
  );

  await Printing.sharePdf(
    bytes: bytes,
    filename: widget.job.invoiceNumber.isEmpty
        ? 'Invoice.pdf'
        : '${widget.job.invoiceNumber}.pdf',
  );
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
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                         Text(
                          isSpanish ? '¿Necesita otra copia?' : 'Need another copy?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _actionButton(
                              icon: Icons.email_outlined,
                              label: isSpanish ? 'Enviar por correo nuevamente' : 'Email Again',
                              color: Colors.blue,
                              onPressed: () {
                                _showMessage(
                                  isSpanish
    ? 'El recibo fue enviado nuevamente por correo electrónico.'
    : 'Receipt email sent again.',
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              icon: Icons.sms_outlined,
                              label: isSpanish ? 'Enviar por texto nuevamente' : 'Text Again',
color: Colors.greenAccent,
onPressed: () {
  _showMessage(
    isSpanish
        ? 'El recibo fue enviado nuevamente por mensaje de texto.'
        : 'Receipt text sent again.',
                                );
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
                      children: [
                         Text(
                          isSpanish ? '¿Cómo lo hicimos?' : 'How did we do?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          isSpanish
    ? 'Sus comentarios nos ayudan a brindar un mejor servicio.'
    : 'Your feedback helps us provide better service.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            _ratingStar(1),
                            _ratingStar(2),
                            _ratingStar(3),
                            _ratingStar(4),
                            _ratingStar(5),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    height: 64,
                    child: ElevatedButton.icon(
                      onPressed: _returnToDashboard,
                      icon: const Icon(
                        Icons.dashboard_outlined,
                        size: 27,
                      ),
                      label:  Text(
                        isSpanish ? 'Volver al panel' : 'Return to Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                   Text(
                    isSpanish
    ? 'Su factura seguirá disponible a través del mismo enlace seguro.'
    : 'Your invoice remains available through the same secure link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
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