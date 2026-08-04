import 'package:flutter/material.dart';
import '../models/job.dart';
import '../services/job_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pdf_preview_screen.dart';
import 'work_board_screen.dart';
class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({
    super.key,
    required this.job,
    required this.languageCode,
  });

  final Job job;
  final String languageCode;

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  bool get isSpanish => widget.languageCode == 'es';
  String? selectedApprovalMethod;
  String? selectedSendMethod;

  final TextEditingController approvalNotesController =
      TextEditingController();

  final List<String> approvalMethods = [
    'Customer Approval',
    'Self Approval',
  ];

  final List<String> sendMethods = [
    'Text Message',
    'Email',
    'Signature',
    'Phone Approval',
    'Print PDF',
  ];

  @override
  void dispose() {
    approvalNotesController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  IconData _approvalIcon(String method) {
    switch (method) {
      case 'Customer Approval':
        return Icons.verified_user_outlined;
      case 'Self Approval':
        return Icons.person_pin_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  IconData _sendIcon(String method) {
    switch (method) {
      case 'Text Message':
        return Icons.sms_outlined;
      case 'Email':
        return Icons.email_outlined;
      case 'Signature':
        return Icons.draw_outlined;
      case 'Phone Approval':
        return Icons.phone_in_talk_outlined;
      case 'Print PDF':
        return Icons.picture_as_pdf_outlined;
      default:
        return Icons.send_outlined;
    }
  }

  Widget _selectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    Color accentColor = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: 0.14)
                : const Color(0xFF0B1624),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accentColor : Colors.white24,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.18),
                  border: Border.all(
                    color: accentColor,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 29,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: selected ? accentColor : Colors.white38,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobDetail({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
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

  Widget _timelineItem({
    required String title,
    required String time,
    required Color color,
    bool completed = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? color : const Color(0xFF0B1624),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    )
                  : null,
            ),
            Container(
              width: 2,
              height: 38,
              color: Colors.white12,
            ),
          ],
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: completed ? Colors.white : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get _canContinue {
    if (selectedApprovalMethod == 'Self Approval') {
      return true;
    }

    return selectedApprovalMethod != null &&
        selectedSendMethod != null;
  }

  Future<void> _continue() async {
  if (!_canContinue) {
    _showMessage(
      isSpanish
          ? 'Primero elija un método de aprobación y un método de envío.'
          : 'Choose an approval method and send method first.',
    );
    return;
  }

  if (selectedApprovalMethod == 'Self Approval') {
  widget.job.approvalStatus = 'Approved';
  widget.job.approvalMethod = 'Self Approval';
  widget.job.approvalRequestedBy = 'Business';
  widget.job.approvalDate = DateTime.now();
  widget.job.notes = approvalNotesController.text.trim();
  widget.job.jobStatus = 'In Progress';
    JobRepository.instance.updateJob(widget.job);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkBoardScreen(
          languageCode: widget.languageCode,
          job: widget.job,
        ),
      ),
    );
    return;
  }

  switch (selectedSendMethod) {
    case 'Text Message':
      if (widget.job.customerPhone.trim().isEmpty) {
        _showMessage(
          isSpanish
              ? 'Este cliente no tiene un número de teléfono guardado.'
              : 'This customer does not have a saved phone number.',
        );
        return;
      }

      final sms = Uri(
        scheme: 'sms',
        path: widget.job.customerPhone.trim(),
        queryParameters: {
          'body': widget.job.estimateNumber.trim().isEmpty
              ? (isSpanish
                  ? 'Su estimado está listo para aprobación.'
                  : 'Your estimate is ready for approval.')
              : (isSpanish
                  ? 'Su estimado ${widget.job.estimateNumber} está listo para aprobación.'
                  : 'Your estimate ${widget.job.estimateNumber} is ready for approval.'),
        },
      );

      final opened = await launchUrl(sms);

      if (!opened) {
        _showMessage(
          isSpanish
              ? 'No se pudo abrir la aplicación de mensajes.'
              : 'Could not open the messaging app.',
        );
        return;
      }
      break;

    case 'Email':
      if (widget.job.customerEmail.trim().isEmpty) {
        _showMessage(
          isSpanish
              ? 'Este cliente no tiene un correo electrónico guardado.'
              : 'This customer does not have a saved email address.',
        );
        return;
      }

      final email = Uri(
        scheme: 'mailto',
        path: widget.job.customerEmail.trim(),
        queryParameters: {
          'subject': widget.job.estimateNumber.trim().isEmpty
              ? (isSpanish
                  ? 'Estimado listo para aprobación'
                  : 'Estimate Ready for Approval')
              : (isSpanish
                  ? 'Estimado ${widget.job.estimateNumber}'
                  : 'Estimate ${widget.job.estimateNumber}'),
          'body': widget.job.estimateNumber.trim().isEmpty
              ? (isSpanish
                  ? 'Su estimado está listo para revisión y aprobación.'
                  : 'Your estimate is ready for review and approval.')
              : (isSpanish
                  ? 'Su estimado ${widget.job.estimateNumber} está listo para revisión y aprobación.'
                  : 'Your estimate ${widget.job.estimateNumber} is ready for review and approval.'),
        },
      );

      final opened = await launchUrl(email);

      if (!opened) {
        _showMessage(
          isSpanish
              ? 'No se pudo abrir la aplicación de correo.'
              : 'Could not open the email app.',
        );
        return;
      }
      break;

    case 'Print PDF':
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfPreviewScreen(
            job: widget.job,
          ),
        ),
      );
      return;

    case 'Signature':
      _showMessage(
        isSpanish
            ? 'La pantalla de firma todavía necesita conectarse.'
            : 'The signature screen still needs to be connected.',
      );
      return;

    case 'Phone Approval':
      if (approvalNotesController.text.trim().isEmpty) {
        _showMessage(
          isSpanish
              ? 'Ingrese una nota que documente la aprobación telefónica.'
              : 'Enter a note documenting the phone approval.',
        );
        return;
      }

      widget.job.approvalStatus = 'Approved';
widget.job.approvalMethod = 'Phone Approval';
widget.job.approvalRequestedBy = 'Customer';
widget.job.approvalDate = DateTime.now();
widget.job.notes = approvalNotesController.text.trim();
widget.job.jobStatus = 'In Progress';
      JobRepository.instance.updateJob(widget.job);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkBoardScreen(
            languageCode: widget.languageCode,
            job: widget.job,
          ),
        ),
      );
      return;
  }

  widget.job.approvalStatus = 'Awaiting Approval';
widget.job.approvalMethod = selectedSendMethod ?? '';
widget.job.approvalRequestedBy = 'Customer';
widget.job.approvalDate = DateTime.now();
widget.job.notes = approvalNotesController.text.trim();
widget.job.jobStatus = 'Awaiting Approval';
  JobRepository.instance.updateJob(widget.job);

  if (!mounted) return;

  Navigator.popUntil(
    context,
    (route) => route.isFirst,
  );
}
Widget _approvalPriceRow({
  required String label,
  required double amount,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';
    final bool customerApprovalSelected =
        selectedApprovalMethod == 'Customer Approval';
        final double laborTotal = widget.job.operations.fold(
  0.0,
  (sum, operation) => sum + operation.laborTotal,
);

final double partsTotal = widget.job.operations.fold(
  0.0,
  (sum, operation) => sum + operation.partsTotal,
);

final double generalChargesTotal = widget.job.generalCharges.fold(
  0.0,
  (sum, charge) => sum + charge.amount,
);

final double estimatedTotal =
    laborTotal + partsTotal + generalChargesTotal;

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
        isSpanish ? 'Aprobar trabajo' : 'Approve Work',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
  isSpanish ? 'Número de trabajo' : 'Job Number',
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
      ? 'Seleccione cómo desea obtener la aprobación del cliente.'
      : 'Choose how you would like to receive customer approval.',
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.45),
                      ),
                    ),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.fact_check_outlined,
                          color: Colors.orange,
                          size: 35,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSpanish ? 'Listo para aprobación' : 'Ready for Approval',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                isSpanish
    ? 'Su trabajo ha sido revisado. Elija cómo desea aprobarlo y continuar.'
    : 'Your work has been reviewed. Choose how you want to approve and continue.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 10),
                        
Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        isSpanish ? 'Información del trabajo' : 'Job Information',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
          ],
  ),
),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _jobDetail(
  label: isSpanish ? 'Cliente' : 'Customer',
  value: widget.job.customerName,
),

_jobDetail(
  label: isSpanish ? 'Equipo' : 'Equipment',
  value: widget.job.equipment,
),

_jobDetail(
  label: isSpanish ? 'Unidad #' : 'Unit #',
  value: widget.job.unitNumber,
),

if (widget.job.vin.isNotEmpty)
  _jobDetail(
    label: 'VIN',
    value: widget.job.vin,
  ),

if (widget.job.mileage.isNotEmpty)
  _jobDetail(
    label: isSpanish ? 'Kilometraje' : 'Mileage',
    value: widget.job.mileage,
  ),
                        
                        const Divider(
                          color: Colors.white12,
                          height: 28,
                        ),
                         Column(
  children: [
    _approvalPriceRow(
      label: isSpanish ? 'Mano de obra' : 'Labor',
      amount: laborTotal,
    ),
    _approvalPriceRow(
      label: isSpanish ? 'Piezas' : 'Parts',
      amount: partsTotal,
    ),
    _approvalPriceRow(
      label: isSpanish
          ? 'Cargos adicionales'
          : 'Other Charges',
      amount: generalChargesTotal,
    ),
    const Divider(
      color: Colors.white24,
      height: 28,
    ),
    Row(
      children: [
        Expanded(
          child: Text(
            isSpanish
                ? 'Total estimado'
                : 'Estimated Total',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),
        ),
        Text(
          '\$${estimatedTotal.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ],
),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    isSpanish
    ? '¿Quién debe aprobar esto?'
    : 'Who should approve this?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...approvalMethods.map((method) {
                    final bool selected =
                        selectedApprovalMethod == method;

                    return _selectionCard(
                      title: method,
                      subtitle: method == 'Customer Approval'
    ? (isSpanish
        ? 'Envíe los detalles del trabajo al cliente para su aprobación.'
        : 'Send the work details to the customer for approval.')
    : (isSpanish
        ? 'Apruebe el trabajo usted mismo y cree la factura ahora.'
        : 'Approve the work yourself and create the invoice now.'),
                      icon: _approvalIcon(method),
                      selected: selected,
                      accentColor: method == 'Customer Approval'
                          ? Colors.orange
                          : Colors.blue,
                      onTap: () {
                        setState(() {
                          selectedApprovalMethod = method;

                          if (method == 'Self Approval') {
                            selectedSendMethod = null;
                          }
                        });
                      },
                    );
                  }),
                  if (customerApprovalSelected) ...[
                    const SizedBox(height: 10),
                    Text(
                      isSpanish
    ? '¿Cómo le gustaría solicitar la aprobación?'
    : 'How would you like to request approval?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...sendMethods.map((method) {
                      final bool selected =
                          selectedSendMethod == method;

                      return _selectionCard(
                        title: method,
                        subtitle: method == 'Text Message'
    ? (isSpanish
        ? 'Envíe un enlace seguro de aprobación por mensaje de texto.'
        : 'Send a secure approval link by text.')
    : method == 'Email'
        ? (isSpanish
            ? 'Envíe un enlace seguro de aprobación por correo electrónico.'
            : 'Send a secure approval link by email.')
        : method == 'Signature'
            ? (isSpanish
                ? 'Haga que el cliente firme directamente en este dispositivo.'
                : 'Have the customer sign directly on this device.')
            : method == 'Phone Approval'
                ? (isSpanish
                    ? 'Registre la aprobación verbal y las notas de aprobación.'
                    : 'Record verbal approval and approval notes.')
                : (isSpanish
                    ? 'Cree un PDF de aprobación para imprimir.'
                    : 'Create a printable approval PDF.'),
                        icon: _sendIcon(method),
                        selected: selected,
                        accentColor: Colors.greenAccent,
                        onTap: () {
                          setState(() {
                            selectedSendMethod = method;
                          });
                        },
                      );
                    }),
                  ],
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.notes_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 10),
                            Text(
                              isSpanish ? 'Notas de aprobación' : 'Approval Notes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: approvalNotesController,
                          minLines: 4,
                          maxLines: 7,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                isSpanish
    ? 'Notas opcionales, contacto de aprobación o instrucciones especiales.'
    : 'Optional notes, approval contact, or special instructions.',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              height: 1.4,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF07111D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.greenAccent,
                          size: 34,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSpanish
    ? 'Registro seguro de aprobación'
    : 'Secure Approval Record',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                isSpanish
    ? 'Las aprobaciones se registran con fecha y hora y se guardan con el trabajo para sus registros.'
    : 'Approvals are time-stamped and stored with the job for your records.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.purpleAccent,
                            ),
                            SizedBox(width: 10),
                            Text(
                              isSpanish ? 'Historial de aprobaciones' : 'Approval History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _timelineItem(
                          title: isSpanish ? 'Trabajo revisado' : 'Work Reviewed',
                          time: 'Today at 9:42 PM',
                          color: Colors.blue,
                          completed: true,
                        ),
                        _timelineItem(
                          title: isSpanish ? 'Aprobación solicitada' : 'Approval Requested',
                          time: 'Waiting',
                          color: Colors.orange,
                        ),
                        _timelineItem(
                          title: isSpanish ? 'Aprobado' : 'Approved',
                          time: isSpanish ? 'En espera' : 'Waiting',
                          color: Colors.greenAccent,
                        ),
                        _timelineItem(
                          title: isSpanish ? 'Factura enviada' : 'Invoice Sent',
                          time: isSpanish ? 'En espera' : 'Waiting',
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 62,
                    child: ElevatedButton.icon(
                      onPressed: _canContinue ? _continue : null,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 28,
                      ),
                      label: Text(
                        selectedApprovalMethod == 'Self Approval'
    ? (isSpanish
        ? 'Aprobar y crear factura'
        : 'Approve & Create Invoice')
    : (isSpanish
        ? 'Solicitar aprobación'
        : 'Request Approval'),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                   Text(
                    isSpanish
    ? 'No se enviará nada hasta que presione el botón de arriba.'
    : 'Nothing will be sent until you press the button above.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
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