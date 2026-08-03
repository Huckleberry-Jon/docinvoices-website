import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';
import 'customer_invoice_screen.dart';

class JobHistoryScreen extends StatefulWidget {
  const JobHistoryScreen({
    super.key,
    required this.languageCode,
    this.onlyPaid = false,
    this.onlyOutstanding = false,
    this.onlyCompleted = false,
  });

  final String languageCode;
  final bool onlyPaid;
  final bool onlyOutstanding;
  final bool onlyCompleted;

  @override
  State<JobHistoryScreen> createState() =>
      _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  final TextEditingController searchController =
      TextEditingController();

  bool get isSpanish => widget.languageCode == 'es';

  bool _isPaid(Job job) {
    final status = job.jobStatus.toLowerCase();

    return job.isPaidInFull ||
        status.contains('paid') ||
        status.contains('payment received') ||
        status.contains('pagado') ||
        status.contains('pago recibido');
  }

  bool _isCompleted(Job job) {
    final status = job.jobStatus.toLowerCase();

    return status.contains('completed') ||
        status.contains('invoiced') ||
        status.contains('paid') ||
        status.contains('payment received') ||
        status.contains('completado') ||
        status.contains('facturado') ||
        status.contains('pagado') ||
        job.invoiceNumber.trim().isNotEmpty;
  }

  List<Job> _filteredJobs() {
    final query = searchController.text
        .trim()
        .toLowerCase();

    Iterable<Job> jobs =
        JobRepository.instance.jobs;

    if (widget.onlyPaid) {
      jobs = jobs.where(_isPaid);
    } else if (widget.onlyOutstanding) {
      jobs = jobs.where(
        (job) =>
            job.invoiceNumber.trim().isNotEmpty &&
            job.balanceDue > 0.01,
      );
    } else if (widget.onlyCompleted) {
      jobs = jobs.where(_isCompleted);
    } else {
      jobs = jobs.where(_isCompleted);
    }

    if (query.isNotEmpty) {
      jobs = jobs.where((job) {
        final searchableText = [
          job.repairOrderNumber,
          job.invoiceNumber,
          job.estimateNumber,
          job.customerName,
          job.equipment,
          job.unitNumber,
          job.vin,
          job.poNumber,
          job.completedDate,
          job.jobStatus,
          job.location,
          job.notes,
          job.transcription,
        ].join(' ').toLowerCase();

        return searchableText.contains(query);
      });
    }

    final results = jobs.toList();

    results.sort((a, b) {
      final aNumber = int.tryParse(
            a.repairOrderNumber,
          ) ??
          int.tryParse(a.invoiceNumber) ??
          0;

      final bNumber = int.tryParse(
            b.repairOrderNumber,
          ) ??
          int.tryParse(b.invoiceNumber) ??
          0;

      return bNumber.compareTo(aNumber);
    });

    return results;
  }

  String _screenTitle() {
    if (widget.onlyPaid) {
      return isSpanish
          ? 'Facturas pagadas'
          : 'Paid Invoices';
    }

    if (widget.onlyOutstanding) {
      return isSpanish
          ? 'Facturas pendientes'
          : 'Outstanding Invoices';
    }

    return isSpanish
        ? 'Historial de trabajos'
        : 'Job History';
  }

  String _recordNumber(Job job) {
    if (job.repairOrderNumber.trim().isNotEmpty) {
      return '${isSpanish ? 'OT' : 'RO'} '
          '${job.repairOrderNumber}';
    }

    if (job.invoiceNumber.trim().isNotEmpty) {
      return '${isSpanish ? 'Factura' : 'Invoice'} '
          '${job.invoiceNumber}';
    }

    if (job.estimateNumber.trim().isNotEmpty) {
      return '${isSpanish ? 'Estimado' : 'Estimate'} '
          '${job.estimateNumber}';
    }

    return isSpanish
        ? 'Sin número'
        : 'No number';
  }

  String _money(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _filteredJobs();

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: isSpanish
                    ? 'Buscar historial'
                    : 'Search history',
                hintText: isSpanish
                    ? 'OT, factura, cliente, unidad o VIN'
                    : 'RO, invoice, customer, unit, or VIN',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon:
                    searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.clear,
                            ),
                          ),
                border:
                    const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            child: Row(
              children: [
                Text(
                  isSpanish
                      ? '${jobs.length} registros'
                      : '${jobs.length} records',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (widget.onlyOutstanding)
                  Text(
                    _money(
                      jobs.fold<double>(
                        0,
                        (total, job) =>
                            total + job.balanceDue,
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: jobs.isEmpty
                ? Center(
                    child: Text(
                      isSpanish
                          ? 'No se encontraron registros.'
                          : 'No records found.',
                    ),
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    separatorBuilder: (
                      context,
                      index,
                    ) =>
                        const SizedBox(height: 10),
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final job = jobs[index];

                      final equipmentLine = [
                        if (job.equipment
                            .trim()
                            .isNotEmpty)
                          job.equipment,
                        if (job.unitNumber
                            .trim()
                            .isNotEmpty)
                          '${isSpanish ? 'Unidad' : 'Unit'} '
                              '${job.unitNumber}',
                      ].join(' • ');

                      return Card(
                        clipBehavior:
                            Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerInvoiceScreen(
                                  languageCode:
                                      widget.languageCode,
                                  job: job,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              16,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    _isPaid(job)
                                        ? Icons
                                            .check_circle_outline
                                        : Icons
                                            .description_outlined,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        _recordNumber(
                                          job,
                                        ),
                                        style:
                                            const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        job.customerName
                                                .trim()
                                                .isEmpty
                                            ? (isSpanish
                                                ? 'Cliente sin nombre'
                                                : 'Unnamed Customer')
                                            : job.customerName,
                                        style:
                                            const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                      if (equipmentLine
                                          .isNotEmpty) ...[
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          equipmentLine,
                                        ),
                                      ],
                                      if (job.vin
                                          .trim()
                                          .isNotEmpty) ...[
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'VIN / SN: '
                                          '${job.vin}',
                                        ),
                                      ],
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        job.jobStatus,
                                        style:
                                            TextStyle(
                                          color: _isPaid(
                                            job,
                                          )
                                              ? Colors
                                                  .green
                                              : Colors
                                                  .orange,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .end,
                                  children: [
                                    Text(
                                      _money(
                                        double.tryParse(
                                              job.estimatedTotal,
                                            ) ??
                                            0,
                                      ),
                                      style:
                                          const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    if (job.balanceDue >
                                        0.01)
                                      Text(
                                        '${isSpanish ? 'Saldo' : 'Due'}: '
                                        '${_money(job.balanceDue)}',
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.orange,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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