import 'package:flutter/material.dart';
import '../models/job.dart';
import 'approval_screen.dart';
import '../models/operation.dart';
import 'operation_details_screen.dart';
import 'new_job_screen.dart';
import 'voice_capture_screen.dart';
import 'schedule_job_screen.dart';
import 'package:docinvoices/services/job_repository.dart';
class ReviewWorkScreen extends StatefulWidget {
  const ReviewWorkScreen({
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
String get location => job.location;
  @override
  State<ReviewWorkScreen> createState() =>
      _ReviewWorkScreenState();
}

class _ReviewWorkScreenState extends State<ReviewWorkScreen> {

  void _showMessage(BuildContext context, String message) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

double get laborTotal {
  return widget.job.operations.fold(
    0.0,
    (sum, operation) => sum + operation.laborTotal,
  );
}

double get partsTotal {
  return widget.job.operations.fold(
    0.0,
    (sum, operation) => sum + operation.partsTotal,
  );
}

double get estimatedTotal {
  return laborTotal + partsTotal;
}

String _money(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}
  void _continueToApproval(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ApprovalScreen(
        languageCode: widget.languageCode,
        job: widget.job,
      ),
    ),
  );
}
Future<void> _scheduleJob() async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ScheduleJobScreen(
        languageCode: widget.languageCode,
        job: widget.job,
      ),
    ),
  );

  if (mounted) {
    setState(() {});
  }
}
Future<void> _addOperation() async {
  final bool isSpanish = widget.languageCode == 'es';
  final controller = TextEditingController();

  final String? title = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
  isSpanish ? 'Agregar operación' : 'Add Operation',),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration:  InputDecoration(
            labelText: isSpanish ? 'Título de la operación' : 'Operation title',
            hintText: isSpanish
    ? 'Ejemplo: Reemplazar bomba de agua'
    : 'Example: Replace Water Pump',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
  isSpanish ? 'Cancelar' : 'Cancel',
),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isEmpty) {
                return;
              }

              Navigator.pop(context, value);
            },
            child: Text(
  isSpanish ? 'Guardar' : 'Save',
),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (title == null || title.isEmpty) {
    return;
  }

  setState(() {
    widget.job.operations.add(
      Operation(
        title: title,
        labor: [],
        parts: [],
      ),
    );
  });
}
  Widget _infoItem({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 27,
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

  Widget _sectionHeader({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Color color,
  VoidCallback? onEdit,
}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
         SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style:  TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
  onPressed: onEdit ??
    () {
      _showMessage(
        context,
        '$title editing will be connected later.',
      );
    },
          icon: Icon(Icons.edit_outlined, color: color),
          label: Text(
  widget.languageCode == 'es' ? 'Editar' : 'Edit',
  style: TextStyle(
    color: color,
    fontSize: 16,
  ),
),
        ),
      ],
    );
  }

  Widget _bulletItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Icon(
              Icons.circle,
              color: color,
              size: 8,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
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
    bool bold = false,
    Color? amountColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: bold ? Colors.white : Colors.white70,
                fontSize: bold ? 20 : 17,
                fontWeight:
                    bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor ?? Colors.white,
              fontSize: bold ? 27 : 17,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1624),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }
Future<void> _editNotes() async {
  final controller = TextEditingController(
    text: widget.job.notes,
  );

  final savedNotes = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          widget.languageCode == 'es'
              ? 'Editar notas'
              : 'Edit Notes',
        ),
        content: TextField(
          controller: controller,
          minLines: 4,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: widget.languageCode == 'es'
                ? 'Ingrese notas...'
                : 'Enter notes...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              widget.languageCode == 'es'
                  ? 'Cancelar'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child: Text(
              widget.languageCode == 'es'
                  ? 'Guardar'
                  : 'Save',
            ),
          ),
        ],
      );
    },
  );

  controller.dispose();

  if (savedNotes == null) {
    return;
  }

  setState(() {
    widget.job.notes = savedNotes;
  });

  JobRepository.instance.updateJob(widget.job);
}
  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
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
  isSpanish
      ? 'Revise su trabajo'
      : 'Review Your Work',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),



                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showMessage(
  context,
  isSpanish
      ? 'La ayuda para esta pantalla estará disponible próximamente.'
      : 'Review help will be connected later.',
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
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF172334),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        '✨ AI Draft',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle,
                            color: Colors.amber,
                            size: 22,
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSpanish
    ? 'Pendiente de revisión'
    : 'Awaiting Review',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                isSpanish
    ? 'Revise los detalles a continuación antes de continuar.'
    : 'Review the details below before continuing.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
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
      _sectionHeader(
  context: context,
  icon: Icons.assignment_outlined,
  title: isSpanish ? 'Información del trabajo' : 'Job Information',
  color: Colors.blue,
  onEdit: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewJobScreen(
          languageCode: widget.languageCode,
          job: widget.job,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  },
),
const SizedBox(height: 16),
      _infoItem(
        icon: Icons.person_outline,
        label: isSpanish ? 'Cliente' : 'Customer',
        value: widget.customerName,
        color: Colors.blue,
      ),
      const Divider(
        color: Colors.white12,
        height: 30,
      ),
      _infoItem(
        icon: Icons.local_shipping_outlined,
        label: isSpanish ? 'Equipo' : 'Equipment',
        value: [
  widget.equipment,
if (widget.unitNumber.isNotEmpty)
  '${isSpanish ? 'Unidad' : 'Unit'} ${widget.unitNumber}',
if (widget.mileage.isNotEmpty)
  '${isSpanish ? 'Millaje' : 'Mileage'}: ${widget.mileage}',
if (widget.vin.isNotEmpty)
  'VIN / Serial: ${widget.vin}',
].where((value) => value.isNotEmpty).join('\n'),
        color: Colors.blue,
      ),
      const Divider(
        color: Colors.white12,
        height: 30,
      ),
 _infoItem(
  icon: Icons.location_on_outlined,
  label: isSpanish ? 'Ubicación' : 'Location',
  value: widget.location.trim().isEmpty
      ? (isSpanish ? 'No especificada' : 'Not specified')
      : widget.location,
  color: Colors.blue,
),
                  const SizedBox(height: 16),
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionHeader(
  context: context,
  icon: Icons.build_outlined,
  title: isSpanish ? 'Servicios realizados' : 'Services Performed',
  color: Colors.blue,
  onEdit: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceCaptureScreen(
          languageCode: widget.languageCode,
          job: widget.job,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  },
),
                       if (widget.transcription.isEmpty)
  _bulletItem(
    isSpanish
        ? 'No se ingresó ningún trabajo.'
        : 'No work entered.',
    Colors.orange,
  )
else


const SizedBox(height: 8),

Align(
  alignment: Alignment.centerLeft,
  child: TextButton.icon(
    onPressed: _addOperation,
    icon: const Icon(Icons.add),
    label: Text(
      isSpanish ? 'Agregar más trabajo' : 'Add More Work',
    ),
  ),
),
  _bulletItem(
    widget.transcription,
    Colors.blue,
  ),
                        const Divider(
                          color: Colors.white12,
                          height: 34,
                        ),
                       _sectionHeader(
  context: context,
  icon: Icons.inventory_2_outlined,
  title: isSpanish ? 'Piezas' : 'Parts',
  color: Colors.greenAccent,
  onEdit: () {
    if (widget.job.operations.isEmpty) {
      _addOperation();
      return;
    }

    _addOperation();
  },
),
                        const SizedBox(height: 8),
                        Row(
  children: [
    Expanded(
      child: Text(
  isSpanish
      ? 'No se ingresaron piezas'
      : 'No parts entered',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 17,
        ),
      ),
    ),
  ],
),
                        const Divider(
                          color: Colors.white12,
                          height: 34,
                        ),
                        _sectionHeader(
  context: context,
  icon: Icons.notes_outlined,
  title: isSpanish ? 'Notas' : 'Notes',
  color: Colors.amber,
  onEdit: _editNotes,
),
                        const SizedBox(height: 6),
                        Text(
  widget.transcription,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 17,
    height: 1.55,
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
                        _sectionHeader(
  context: context,
  icon: Icons.calculate_outlined,
  title: isSpanish ? 'Total estimado' : 'Estimated Total',
  color: Colors.purpleAccent,
  onEdit: () async {
    if (widget.job.operations.isEmpty) {
      _addOperation();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OperationDetailsScreen(
          operation: widget.job.operations.first,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  },
),
                        const SizedBox(height: 4),
                        _priceRow(
  label: isSpanish ? 'Mano de obra' : 'Labor',
  amount: laborTotal > 0
      ? _money(laborTotal)
      : isSpanish
          ? 'No ingresado'
          : 'Not entered',
),

_sectionHeader(
  context: context,
  icon: Icons.inventory_2_outlined,
  title: isSpanish ? 'Piezas' : 'Parts',
  color: Colors.greenAccent,
  onEdit: () async {
    if (widget.job.operations.isEmpty) {
      _addOperation();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OperationDetailsScreen(
          operation: widget.job.operations.first,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  },
),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
  isSpanish ? 'Impuesto sobre ventas' : 'Sales Tax',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  InkWell(
                                    onTap: () {
                                      _showMessage(
                                        context,
isSpanish
    ? 'El impuesto sobre ventas se basa en la configuración de impuestos guardada.'
    : 'Sales tax is based on your saved tax settings.',
                                      );
                                    },
                                    child: const Icon(
                                      Icons.info_outline,
                                      color: Colors.white54,
                                      size: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
  isSpanish
      ? 'Calculado en la factura'
      : 'Calculated on invoice',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.white24,
                          height: 28,
                        ),
                        _priceRow(
  label: 'TOTAL',
  amount: estimatedTotal > 0
      ? _money(estimatedTotal)
      : isSpanish
          ? 'Pendiente'
          : 'Pending',
  bold: true,
  amountColor: Colors.purpleAccent,
),
                        const Divider(
                          color: Colors.white12,
                          height: 24,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isSpanish
    ? 'El impuesto sobre ventas se calcula según la configuración de su negocio.'
    : 'Sales tax is calculated from your business settings.',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _showMessage(
                                  context,
                                  isSpanish
    ? 'La configuración de impuestos estará disponible próximamente.'
    : 'Tax Settings will be connected later.',
                                );
                              },
                              child: Text(
                               isSpanish
    ? 'Ver configuración de impuestos'
    : 'View Tax Settings',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

Row(
  children: [
    Expanded(
      child: SizedBox(
        height: 60,
        child: OutlinedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewJobScreen(
                  languageCode: widget.languageCode,
                  job: widget.job,
                ),
              ),
            );

            if (mounted) {
              setState(() {});
            }
          },
          icon: const Icon(Icons.edit_outlined),
          label: Text(
            isSpanish ? 'Editar todo' : 'Edit All',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: SizedBox(
        height: 60,
        child: OutlinedButton.icon(
          onPressed: _scheduleJob,
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(
            isSpanish ? 'Programar' : 'Schedule',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange,
            side: const BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      flex: 2,
      child: SizedBox(
        height: 60,
        child: ElevatedButton.icon(
          onPressed: () {
            _continueToApproval(context);
          },
          iconAlignment: IconAlignment.end,
          icon: const Icon(
            Icons.arrow_forward,
            size: 28,
          ),
          label: Text(
            isSpanish ? 'Continuar' : 'Continue',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    ),
  ],
),
                  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      isSpanish ? 'Operaciones' : 'Operations',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
const SizedBox(height: 12),
    if (widget.job.operations.isEmpty)
      Text(
        isSpanish
    ? 'Aún no se han agregado operaciones.'
    : 'No operations added yet.',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 15,
        ),
      )
    else
      ...widget.job.operations.map(
       (operation) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OperationDetailsScreen(
            operation: operation,
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1624),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.build_circle_outlined,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              operation.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white54,
          ),
        ],
      ),
    ),
  ),
),
      ),
  ],
),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.white38,
                        size: 17,
                      ),
                      SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          isSpanish
    ? 'No se enviará ni se cobrará nada hasta que continúe.'
    : 'Nothing is sent or charged until you continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                  )
          ],
        ),
      ),
    ),
  ),
      ),
);
  }
}