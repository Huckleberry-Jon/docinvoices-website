import 'package:flutter/material.dart';
import '../models/labor_item.dart';
import '../models/job.dart';
import 'customer_invoice_screen.dart';

class WorkCompletedScreen extends StatefulWidget {
  const WorkCompletedScreen({
    super.key,
    required this.job,
  });

  final Job job;
  

  @override
  State<WorkCompletedScreen> createState() =>
      _WorkCompletedScreenState();
}

class _WorkCompletedScreenState extends State<WorkCompletedScreen> {
  bool showServiceDetails = false;
 final List<LaborItem> laborItems = [];

double get laborTotal {
  return laborItems.fold(
    0.0,
    (total, item) => total + item.total,
  );
}
 
 void _showAddLaborDialog() {
  final descriptionController = TextEditingController();
  final hoursController = TextEditingController();
  final rateController = TextEditingController();
  

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Labor'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Example: Brake repair',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hoursController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Hours',
                  hintText: 'Example: 2.5',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: rateController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Hourly Rate',
                  hintText: 'Example: 125.00',
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final description = descriptionController.text.trim();
              final hours = double.tryParse(hoursController.text.trim());
              final rate = double.tryParse(rateController.text.trim());

              if (description.isEmpty || hours == null || rate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Enter a description, hours, and hourly rate.',
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
child: const Text('Save Labor'),
),
],
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
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          _showMessage('$label will be connected later.');
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
          _showMessage('$label photo viewer will be connected later.');
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
              const Text(
                'Tap to view',
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
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Work Completed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                               'Invoice Number',
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
                            'Customer help will be connected later.',
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
                    child: const Row(
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
                                'Your repair is complete',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Thank you for choosing Huckleberry’s Diesel Services. Review the completed work and supporting details below.',
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
                        const Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blue,
                              size: 29,
                            ),
                            SizedBox(width: 11),
                            Text(
                              'Job Information',
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
                          label: 'Customer',
                          value: widget.job.customerName,
                        ),
                        _detailRow(
                          label: 'Equipment',
                          value: widget.job.equipment,
                        ),
                        _detailRow(
                          label: 'Unit #',
                          value: widget.job.unitNumber,
                        ),
                        _detailRow(
                          label: 'VIN / Serial Number',
                          value: widget.job.vin,
                        ),
                        _detailRow(
  label: 'Mileage',
  value: widget.job.mileage,
                        ),
                        _detailRow(
  label: 'PO Number',
  value: widget.job.poNumber,
),

_detailRow(
  label: 'Completed',
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
                                        'Services Completed',
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
                                        ? 'No service details'
                                        : 'Completed service details',
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
      ? 'No work details entered.'
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
                        const Row(
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
                                    'Proof of Work',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '3 photos included',
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
                              label: 'Before',
                              icon: Icons.image_outlined,
                            ),
                            const SizedBox(width: 14),
                            _photoPlaceholder(
                              label: 'After',
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
                                'Photo gallery will be connected later.',
                              );
                            },
                            icon: const Icon(
                              Icons.collections_outlined,
                            ),
                            label: const Text(
                              'View All Photos',
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
                    child: const Row(
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
                                'Customer approval recorded',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Approval details will be available in a future update.',
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
                        const Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.orange,
                              size: 31,
                            ),
                            SizedBox(width: 11),
                            Text(
                              'Invoice Summary',
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
    label: const Text(
      'Add Labor',
      style: TextStyle(fontSize: 17),
    ),
  ),
),

const SizedBox(height: 18),
if (laborItems.isEmpty)
  _priceRow(
    label: 'Labor',
    amount: 'Not entered',
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
      label: 'Line Total',
      amount: '\$${item.total.toStringAsFixed(2)}',
    ),
    const Divider(
      color: Colors.white12,
      height: 20,
    ),
  ],
  _priceRow(
    label: 'Labor Total',
    amount: '\$${laborTotal.toStringAsFixed(2)}',
  ),
],
_priceRow(
  label: 'Parts',
  amount: 'Not entered',
),
_priceRow(
  label: 'Sales Tax',
  amount: 'Calculated on invoice',
),
const Divider(
  color: Colors.white24,
  height: 30,
),
_priceRow(
  label: 'TOTAL',
  amount: laborTotal > 0
      ? '\$${laborTotal.toStringAsFixed(2)}'
      : 'Pending',
  total: true,
),
                        const SizedBox(height: 8),
                        const Text(
                          'The work, photos, and approval above provide documentation supporting this total.',
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
                        label: 'Email',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        icon: Icons.sms_outlined,
                        label: 'Text',
                        color: Colors.greenAccent,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        icon: Icons.picture_as_pdf_outlined,
                        label: 'PDF',
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        color: Colors.purpleAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 72,
                    child: ElevatedButton(
                      onPressed: () {
                       Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CustomerInvoiceScreen(
   customerName: widget.job.customerName,
transcription: widget.job.transcription,
equipment: widget.job.equipment,
unitNumber: widget.job.unitNumber,
vin: widget.job.vin,
mileage: widget.job.mileage,
poNumber: widget.job.poNumber,
completedDate: widget.job.completedDate,
estimatedTotal: widget.job.estimatedTotal,
  
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Complete Payment',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                             'Invoice Total',
                            style: TextStyle(
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
                        const Text(
                          'Questions or need service again?',
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
                                    'Calling the business will be connected later.',
                                  );
                                },
                                icon: const Icon(
                                  Icons.phone_outlined,
                                ),
                                label: const Text('Call Business'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showMessage(
                                    'Scheduling service will be connected later.',
                                  );
                                },
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                ),
                                label:
                                    const Text('Schedule Service'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Created with DocInvoices',
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