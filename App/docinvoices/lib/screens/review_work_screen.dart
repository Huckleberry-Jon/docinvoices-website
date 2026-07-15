import 'package:flutter/material.dart';

import 'approval_screen.dart';

class ReviewWorkScreen extends StatelessWidget {
  const ReviewWorkScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _continueToApproval(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApprovalScreen(),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(width: 12),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            _showMessage(
              context,
              '$title editing will be connected later.',
            );
          },
          icon: Icon(Icons.edit_outlined, color: color),
          label: Text(
            'Edit',
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

  @override
  Widget build(BuildContext context) {
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
                      const Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Review Your Work',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Job #260714-001',
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
                            context,
                            'Review help will be connected later.',
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
                    child: const Row(
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
                                'Awaiting Review',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Review the details below before continuing.',
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoItem(
                          icon: Icons.person_outline,
                          label: 'Customer',
                          value: 'Mike Smith\n(555) 555-1212',
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        _infoItem(
                          icon: Icons.local_shipping_outlined,
                          label: 'Equipment',
                          value: '2022 Peterbilt 579\nUnit 215',
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        _infoItem(
                          icon: Icons.location_on_outlined,
                          label: 'Location',
                          value: 'Houston, TX',
                          color: Colors.blue,
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
                          icon: Icons.build_outlined,
                          title: 'Services Performed',
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 8),
                        _bulletItem(
                          'Replaced starter',
                          Colors.blue,
                        ),
                        _bulletItem(
                          'Cleaned battery terminals',
                          Colors.blue,
                        ),
                        _bulletItem(
                          'Tested charging system',
                          Colors.blue,
                        ),
                        _bulletItem(
                          'Verified proper starting',
                          Colors.blue,
                        ),
                        const Divider(
                          color: Colors.white12,
                          height: 34,
                        ),
                        _sectionHeader(
                          context: context,
                          icon: Icons.inventory_2_outlined,
                          title: 'Parts',
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '1 × Delco Starter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              '\$412.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                '2 × Battery Terminal Ends',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              '\$50.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
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
                          title: 'Notes',
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Truck starts normally.\n'
                          'No further issues found.',
                          style: TextStyle(
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
                          title: 'Estimated Total',
                          color: Colors.purpleAccent,
                        ),
                        const SizedBox(height: 4),
                        _priceRow(
                          label: 'Labor',
                          amount: '\$375.00',
                        ),
                        _priceRow(
                          label: 'Parts',
                          amount: '\$462.00',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text(
                                    'Sales Tax (8.25%)',
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
                                        'Sales tax is based on your saved tax settings.',
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
                            const Text(
                              '\$38.12',
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
                          amount: '\$875.12',
                          bold: true,
                          amountColor: Colors.purpleAccent,
                        ),
                        const Divider(
                          color: Colors.white12,
                          height: 24,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Sales tax is calculated from your business settings.',
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
                                  'Tax Settings will be connected later.',
                                );
                              },
                              child: const Text(
                                'View Tax Settings',
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
                            onPressed: () {
                              _showMessage(
                                context,
                                'Edit All will be connected later.',
                              );
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text(
                              'Edit All',
                              style: TextStyle(fontSize: 18),
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
                      const SizedBox(width: 14),
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
                            label: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
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
                          'Nothing is sent or charged until you continue.',
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
            ),
          ),
        ),
      ),
    );
  }
}