import 'package:flutter/material.dart';
import '../services/job_repository.dart';
import 'review_work_screen.dart';
import 'customer_invoice_screen.dart';
class ActiveJobsScreen extends StatelessWidget {
  
 const ActiveJobsScreen({
  super.key,
  required this.languageCode,
});

final String languageCode;
  @override
  Widget build(BuildContext context) {
    final jobs = JobRepository.instance.activeJobs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Jobs'),
      ),
      body: jobs.isEmpty
    ? const Center(
        child: Text(
          'No Active Jobs',
          style: TextStyle(fontSize: 18),
        ),
      )
    : ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          return ListTile(
            leading: const Icon(Icons.build),
            title: Text(job.customerName),
            subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(job.equipment),
    const SizedBox(height: 4),
    Text(
      job.jobStatus,
      style: TextStyle(
        color: job.jobStatus == 'Estimate'
            ? Colors.orange
            : job.jobStatus == 'In Progress'
                ? Colors.blue
                : job.jobStatus == 'Invoice Ready'
                    ? Colors.green
                    : Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
  final opensAsInvoice =
      job.invoiceNumber.trim().isNotEmpty ||
      job.jobStatus == 'Invoice Ready' ||
      job.jobStatus == 'Invoiced' ||
      job.jobStatus == 'Sent' ||
      job.jobStatus == 'Partially Paid';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => opensAsInvoice
          ? CustomerInvoiceScreen(
              languageCode: languageCode,
              job: job,
            )
          : ReviewWorkScreen(
              languageCode: languageCode,
              job: job,
            ),
    ),
  );
},
          );
        },
      ),
      );
  }
}