import 'package:flutter/material.dart';

import 'payment_received_screen.dart';

class CustomerInvoiceScreen extends StatefulWidget {
  const CustomerInvoiceScreen({
  super.key,
  required this.transcription,
});

final String transcription;

  @override
  State<CustomerInvoiceScreen> createState() =>
      _CustomerInvoiceScreenState();
}

class _CustomerInvoiceScreenState
    extends State<CustomerInvoiceScreen> {
  bool showServiceDetails = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _completePayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentReceivedScreen(),
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
                              'Customer Invoice',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Invoice #10518',
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
                                'Thank you for choosing your service provider.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Review the completed work and supporting details before completing payment.',
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
                              Icons.task_alt,
                              color: Colors.greenAccent,
                              size: 30,
                            ),
                            SizedBox(width: 11),
                            Text(
                              'Job Progress',
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
                          text: 'Diagnosis completed',
                        ),
                        _progressItem(
                          text: 'Repair completed',
                        ),
                        _progressItem(
                          text: 'Quality check passed',
                        ),
                        _progressItem(
                          text: 'Customer approval received',
                        ),
                        _progressItem(
                          text: 'Ready for payment',
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
                          value: 'Customer Name',
                        ),
                        _detailRow(
                          label: 'Equipment',
                          value: 'Equipment Description',
                        ),
                        _detailRow(
                          label: 'Unit #',
                          value: 'Unit Number',
                        ),
                        _detailRow(
                          label: 'VIN',
                          value: 'VIN Number',
                        ),
                        _detailRow(
                          label: 'Mileage',
                          value: 'Mileage',
                        ),
                        _detailRow(
                          label: 'PO Number',
                          value: 'PO Number',
                        ),
                        _detailRow(
                          label: 'Completed',
                          value: 'Completed',
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
                                const Expanded(
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
                                        '5 completed services',
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
                            _photoBox(
                              label: 'Before',
                              icon: Icons.image_outlined,
                            ),
                            const SizedBox(width: 14),
                            _photoBox(
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
                                'Customer Approval',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Approved by Mike Smith',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'July 15, 2026 at 8:42 PM • Text Message',
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
                        const SizedBox(height: 17),
                        _priceRow(
                          label: 'Labor',
                          amount: '\$375.00',
                        ),
                        _priceRow(
                          label: 'Parts',
                          amount: '\$462.00',
                        ),
                        _priceRow(
                          label: 'Sales Tax ',
                          amount: '\$38.12',
                        ),
                        const Divider(
                          color: Colors.white24,
                          height: 30,
                        ),
                        _priceRow(
                          label: 'TOTAL',
                          amount: '\$875.12',
                          total: true,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The completed work, proof photos, and customer approval above support this total.',
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
                        icon: Icons.link,
  label: 'Secure Link',
  color: Colors.purpleAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 76,
                    child: ElevatedButton(
                      onPressed: _completePayment,
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
                                label: const Text('Schedule Again'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Thank you for your business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 9),
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