import 'package:flutter/material.dart';

import '../services/job_repository.dart';
import 'review_work_screen.dart';

class EstimatesScreen extends StatefulWidget {
  const EstimatesScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<EstimatesScreen> createState() =>
      _EstimatesScreenState();
}

class _EstimatesScreenState extends State<EstimatesScreen> {
  bool showDeclined = false;

  String get languageCode => widget.languageCode;
Future<void> _declineEstimate(job) async {
  final bool isSpanish = languageCode == 'es';

  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        isSpanish
            ? 'Rechazar cotización'
            : 'Decline Estimate',
      ),
      content: Text(
        isSpanish
            ? '¿Marcar esta cotización como rechazada?'
            : 'Mark this estimate as declined?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, false);
          },
          child: Text(
            isSpanish ? 'Cancelar' : 'Cancel',
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(dialogContext, true);
          },
          child: Text(
            isSpanish ? 'Rechazar' : 'Decline',
          ),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  job.jobStatus = 'Declined';
  job.approvalStatus = 'Declined';
  job.approvalDate = DateTime.now();

  JobRepository.instance.updateJob(job);
  await JobRepository.instance.save();

  if (!mounted) return;

  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    
    final bool isSpanish = languageCode == 'es';

   final estimates = JobRepository.instance.jobs
    .where(
      (job) => showDeclined
          ? job.jobStatus == 'Declined'
          : job.jobStatus == 'Estimate',
    )
    .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Cotizaciones' : 'Estimates',
        ),
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(16),
      child: SegmentedButton<bool>(
        segments: [
          ButtonSegment<bool>(
            value: false,
            icon: const Icon(Icons.pending_actions),
            label: Text(
              isSpanish ? 'Abiertas' : 'Open',
            ),
          ),
          ButtonSegment<bool>(
            value: true,
            icon: const Icon(Icons.history),
            label: Text(
              isSpanish ? 'Rechazadas' : 'Declined',
            ),
          ),
        ],
        selected: {showDeclined},
        onSelectionChanged: (selection) {
          setState(() {
            showDeclined = selection.first;
          });
        },
      ),
    ),

    Expanded(
      child: estimates.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay cotizaciones abiertas.'
                    : 'No open estimates.',
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: estimates.length,
              itemBuilder: (context, index) {
                final job = estimates[index];

                return ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(job.customerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.equipment),
                      if (job.unitNumber.trim().isNotEmpty)
                        Text(
                          isSpanish
                              ? 'Unidad: ${job.unitNumber}'
                              : 'Unit: ${job.unitNumber}',
                        ),
                      if (job.operations.isNotEmpty)
                        Text(job.operations.first.title),
                    ],
                  ),
                  isThreeLine: true,
                 trailing: showDeclined
    ? const Icon(Icons.history)
    : IconButton(
        icon: const Icon(
          Icons.cancel_outlined,
          color: Colors.redAccent,
        ),
        tooltip: isSpanish
            ? 'Rechazar cotización'
            : 'Decline Estimate',
        onPressed: () {
          _declineEstimate(job);
        },
      ),
                );
              },
            ),
            ),
          ],
        ),
      );
    }
  }