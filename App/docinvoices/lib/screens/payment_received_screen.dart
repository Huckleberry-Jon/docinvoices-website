import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class PaymentReceivedScreen extends StatefulWidget {
  const PaymentReceivedScreen({
    super.key,
    required this.customerName,
    required this.estimatedTotal,
  });

  final String customerName;
  final String estimatedTotal;
  @override
  State<PaymentReceivedScreen> createState() =>
      _PaymentReceivedScreenState();
}

class _PaymentReceivedScreenState
    extends State<PaymentReceivedScreen> {
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
        builder: (context) => const DashboardScreen(),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
          'Thank you for your $rating-star rating.',
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

                  const Text(
                    'Payment Received',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Invoice Complete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                                        'Your payment was processed successfully.',
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
                        const Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              color: Colors.greenAccent,
                              size: 31,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Payment Receipt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'PAID',
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
                          label: 'Invoice',
                          value: 'Pending',
                        ),
                        _detailRow(
                          label: 'Customer',
                         value: widget.customerName,
                        ),
                        _detailRow(
                          label: 'Payment Date',
                          value: 'Not available',
                        ),
                        _detailRow(
                          label: 'Payment Time',
                          value: 'Not available',
                        ),
                        _detailRow(
                          label: 'Payment Method',
                          value: 'Payment integration not connected',
                        ),
                        const Divider(
                          color: Colors.white24,
                          height: 28,
                        ),
                        _detailRow(
                          label: 'Amount Paid',
                          value: 'Not available',
                          emphasize: true,
                          valueColor: Colors.greenAccent,
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
                        const Row(
                          children: [
                            Icon(
                              Icons.send_outlined,
                              color: Colors.blue,
                              size: 29,
                            ),
                            SizedBox(width: 11),
                            Text(
                              'Receipt Delivered',
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
  title: 'Email Delivery',
  subtitle: 'Available after email setup is connected.',
  color: Colors.blue,
),
                       _deliveryRow(
  icon: Icons.sms_outlined,
  title: 'Text Delivery',
  subtitle: 'Available after text messaging is connected.',
  color: Colors.greenAccent,
),
                        _deliveryRow(
  icon: Icons.picture_as_pdf_outlined,
  title: 'Invoice PDF',
  subtitle: 'PDF delivery will be connected before release.',
  color: Colors.redAccent)
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Download a Copy',
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
                              onPressed: () {
                                _showMessage(
                                  'Receipt download will be connected later.',
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              icon:
                                  Icons.picture_as_pdf_outlined,
                              label: 'Invoice PDF',
                              color: Colors.redAccent,
                              onPressed: () {
                                _showMessage(
                                  'Invoice PDF download will be connected later.',
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
                        const Text(
                          'Need another copy?',
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
                              label: 'Email Again',
                              color: Colors.blue,
                              onPressed: () {
                                _showMessage(
                                  'Receipt email sent again.',
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _actionButton(
                              icon: Icons.sms_outlined,
                              label: 'Text Again',
                              color: Colors.greenAccent,
                              onPressed: () {
                                _showMessage(
                                  'Receipt text sent again.',
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
                        const Text(
                          'How did we do?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your feedback helps us provide better service.',
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
                      label: const Text(
                        'Return to Dashboard',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Your invoice remains available through the same secure link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
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