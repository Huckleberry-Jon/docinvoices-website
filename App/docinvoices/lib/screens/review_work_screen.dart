import 'package:flutter/material.dart';
import '../models/job.dart';
import 'approval_screen.dart';
import '../models/operation.dart';
import 'operation_details_screen.dart';
import 'new_job_screen.dart';
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
  Widget _operationCard(Operation operation) {
  return InkWell(
    onTap: () async {
      await Navigator.push(
        context,
       MaterialPageRoute(
  builder: (_) => OperationDetailsScreen(
    languageCode: widget.languageCode,
    operation: operation,
  ),

        ),
      );

      if (mounted) {
        setState(() {});
      }
    },
    borderRadius: BorderRadius.circular(14),
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF07111D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.build_circle_outlined,
            color: Colors.orange,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              operation.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
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
      ? 'Orden de reparación'
      : 'Repair Order',
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
    child: Text(
     isSpanish
    ? 'Preparar para aprobación'
    : 'Prepare for Approval',
      style: const TextStyle(
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
    ? 'Revise las operaciones, la mano de obra, las piezas y los cargos antes de continuar.'
    : 'Review operations, labor, parts, and charges before continuing.',
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
  title: isSpanish
    ? 'Información de la orden de servicio'
    : 'Service Order Information',
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
  title: isSpanish ? 'Operaciones' : 'Operations',
  color: Colors.blue,
  onEdit: null,
),

const SizedBox(height: 8),

if (widget.job.operations.isEmpty)
  _bulletItem(
    isSpanish
        ? 'No hay operaciones agregadas.'
        : 'No operations added.',
    Colors.orange,
  )
else
  ...widget.job.operations.map(
    (operation) => _operationCard(operation),
  ),

const SizedBox(height: 8),

Align(
  alignment: Alignment.centerLeft,
  child: TextButton.icon(
    onPressed: _addOperation,
    icon: const Icon(Icons.add),
    label: Text(
      isSpanish
          ? 'Agregar operación'
          : 'Add Operation',
    ),
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
          const Icon(
            Icons.verified_outlined,
            color: Colors.purpleAccent,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isSpanish
                  ? 'Listo para aprobación'
                  : 'Ready for Approval',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        isSpanish
            ? 'Revise las operaciones antes de continuar.'
            : 'Review the operations before continuing.',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 18),
      SizedBox(
        height: 54,
        child: ElevatedButton.icon(
          onPressed: () {
            _continueToApproval(context);
          },
          iconAlignment: IconAlignment.end,
          icon: const Icon(
            Icons.arrow_forward,
          ),
          label: Text(
            isSpanish
                ? 'Continuar a aprobación'
                : 'Continue to Approval',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  ),
),
                  const SizedBox(height: 20),

Row(
  children: [
    Expanded(
  flex: 2,
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
  isSpanish ? 'Editar' : 'Edit',
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
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
  flex: 2,
      child: SizedBox(
        height: 60,
        child: OutlinedButton.icon(
          onPressed: _scheduleJob,
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(
  isSpanish ? 'Programar' : 'Schedule',
  style: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
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

    
    
  ],
),
                  const SizedBox.shrink(),
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