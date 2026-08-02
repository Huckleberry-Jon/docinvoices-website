import 'package:flutter/material.dart';
import 'package:docinvoices/services/job_repository.dart';
import '../models/job.dart';
import '../models/operation.dart';
import 'operation_details_screen.dart';

import 'work_completed_screen.dart';

class WorkBoardScreen extends StatefulWidget {
  const WorkBoardScreen({
    super.key,
    required this.languageCode,
    required this.job,
  });

  final String languageCode;
  final Job job;

  @override
  State<WorkBoardScreen> createState() => _WorkBoardScreenState();
}

class _WorkBoardScreenState extends State<WorkBoardScreen> {
  Future<void> _addOperation() async {
    final bool isSpanish = widget.languageCode == 'es';
    final controller = TextEditingController();

    final String? title = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isSpanish ? 'Agregar operación' : 'Add Operation',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: isSpanish ? 'Queja' : 'Complaint',
              hintText: isSpanish
                  ? 'Ejemplo: No arranca'
                  : 'Example: No start',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(isSpanish ? 'Cancelar' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: Text(isSpanish ? 'Guardar' : 'Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (title == null || title.isEmpty || !mounted) {
      return;
    }

    final operation = Operation(
      title: title,
      labor: [],
      parts: [],
    );

    setState(() {
      widget.job.operations.add(operation);
    });

    await _openOperation(operation);
  }

  Future<void> _openOperation(Operation operation) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050B14),
        foregroundColor: Colors.white,
        title: Text(
          isSpanish ? 'Tablero de trabajo' : 'Work Board',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.job.customerName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.job.equipment,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isSpanish ? 'Operaciones' : 'Operations',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addOperation,
                    icon: const Icon(Icons.add),
                    label: Text(
                      isSpanish ? 'Agregar' : 'Add',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: widget.job.operations.isEmpty
                    ? Center(
                        child: Text(
                          isSpanish
                              ? 'Aún no hay operaciones.'
                              : 'No operations yet.',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 17,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: widget.job.operations.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final operation =
                              widget.job.operations[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _openOperation(operation),
                            child: Container(
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
                                    size: 30,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          operation.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          operation.repairDescription
                                                  .trim()
                                                  .isEmpty
                                              ? (isSpanish
                                                  ? 'Reparación pendiente'
                                                  : 'Repair pending')
                                              : (isSpanish
                                                  ? 'Reparación registrada'
                                                  : 'Repair recorded'),
                                          style: TextStyle(
                                            color: operation
                                                    .repairDescription
                                                    .trim()
                                                    .isEmpty
                                                ? Colors.orange
                                                : Colors.greenAccent,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
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
                        },
                      ),
              ),
              const SizedBox(height: 14),
SizedBox(
  height: 58,
  child: ElevatedButton.icon(
    onPressed: () {
      widget.job.jobStatus = 'Completed';

      JobRepository.instance.updateJob(widget.job);

     Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => WorkCompletedScreen(
      languageCode: widget.languageCode,
      job: widget.job,
    ),
  ),
);
    },
    iconAlignment: IconAlignment.end,
    icon: const Icon(Icons.check_circle_outline),
    label: Text(
      isSpanish ? 'Completar trabajo' : 'Complete Work',
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
      ),
    );
  }
}