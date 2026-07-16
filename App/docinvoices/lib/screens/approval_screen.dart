import 'package:flutter/material.dart';
import 'work_completed_screen.dart';
class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({
    super.key,
    required this.transcription,
  });

  final String transcription;

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  String? selectedApprovalMethod;
  String? selectedSendMethod;

  final TextEditingController approvalNotesController =
      TextEditingController();

  final List<String> approvalMethods = [
    'Customer Approval',
    'Self Approval',
  ];

  final List<String> sendMethods = [
    'Text Message',
    'Email',
    'Signature',
    'Phone Approval',
    'Print PDF',
  ];

  @override
  void dispose() {
    approvalNotesController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  IconData _approvalIcon(String method) {
    switch (method) {
      case 'Customer Approval':
        return Icons.verified_user_outlined;
      case 'Self Approval':
        return Icons.person_pin_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  IconData _sendIcon(String method) {
    switch (method) {
      case 'Text Message':
        return Icons.sms_outlined;
      case 'Email':
        return Icons.email_outlined;
      case 'Signature':
        return Icons.draw_outlined;
      case 'Phone Approval':
        return Icons.phone_in_talk_outlined;
      case 'Print PDF':
        return Icons.picture_as_pdf_outlined;
      default:
        return Icons.send_outlined;
    }
  }

  Widget _selectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    Color accentColor = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? accentColor.withValues(alpha: 0.14)
                : const Color(0xFF0B1624),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accentColor : Colors.white24,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.18),
                  border: Border.all(
                    color: accentColor,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 29,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: selected ? accentColor : Colors.white38,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobDetail({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
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

  Widget _timelineItem({
    required String title,
    required String time,
    required Color color,
    bool completed = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? color : const Color(0xFF0B1624),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    )
                  : null,
            ),
            Container(
              width: 2,
              height: 38,
              color: Colors.white12,
            ),
          ],
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: completed ? Colors.white : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get _canContinue {
    if (selectedApprovalMethod == 'Self Approval') {
      return true;
    }

    return selectedApprovalMethod != null &&
        selectedSendMethod != null;
  }

  void _continue() {
    if (!_canContinue) {
      _showMessage(
        'Choose an approval method and send method first.',
      );
      return;
    }
Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const WorkCompletedScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final bool customerApprovalSelected =
        selectedApprovalMethod == 'Customer Approval';

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
                              'Approve Work',
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
                            'Approval help will be connected later.',
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.45),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.fact_check_outlined,
                          color: Colors.orange,
                          size: 35,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ready for Approval',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Your work has been reviewed. Choose how you want to approve and continue.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Job Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _jobDetail(
                          label: 'Customer',
                          value: 'Mike Smith Trucking',
                        ),
                        _jobDetail(
                          label: 'Equipment',
                          value: '2022 Peterbilt 579',
                        ),
                        _jobDetail(
                          label: 'Unit #',
                          value: '215',
                        ),
                        _jobDetail(
                          label: 'VIN',
                          value: '1XPBDP9X7ND123456',
                        ),
                        _jobDetail(
                          label: 'Mileage',
                          value: '542,811',
                        ),
                        _jobDetail(
                          label: 'PO Number',
                          value: 'PO-45821',
                        ),
                        const Divider(
                          color: Colors.white12,
                          height: 28,
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Invoice Total',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Text(
                              '\$875.12',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Who should approve this?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...approvalMethods.map((method) {
                    final bool selected =
                        selectedApprovalMethod == method;

                    return _selectionCard(
                      title: method,
                      subtitle: method == 'Customer Approval'
                          ? 'Send the work details to the customer for approval.'
                          : 'Approve the work yourself and create the invoice now.',
                      icon: _approvalIcon(method),
                      selected: selected,
                      accentColor: method == 'Customer Approval'
                          ? Colors.orange
                          : Colors.blue,
                      onTap: () {
                        setState(() {
                          selectedApprovalMethod = method;

                          if (method == 'Self Approval') {
                            selectedSendMethod = null;
                          }
                        });
                      },
                    );
                  }),
                  if (customerApprovalSelected) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'How would you like to request approval?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...sendMethods.map((method) {
                      final bool selected =
                          selectedSendMethod == method;

                      return _selectionCard(
                        title: method,
                        subtitle: method == 'Text Message'
                            ? 'Send a secure approval link by text.'
                            : method == 'Email'
                                ? 'Send a secure approval link by email.'
                                : method == 'Signature'
                                    ? 'Have the customer sign directly on this device.'
                                    : method == 'Phone Approval'
                                        ? 'Record verbal approval and approval notes.'
                                        : 'Create a printable approval PDF.',
                        icon: _sendIcon(method),
                        selected: selected,
                        accentColor: Colors.greenAccent,
                        onTap: () {
                          setState(() {
                            selectedSendMethod = method;
                          });
                        },
                      );
                    }),
                  ],
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.notes_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Approval Notes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: approvalNotesController,
                          minLines: 4,
                          maxLines: 7,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Optional notes, approval contact, or special instructions.',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              height: 1.4,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF07111D),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.greenAccent,
                          size: 34,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Approval Record',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Approvals are time-stamped and stored with the job for your records.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1624),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.purpleAccent,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Approval History',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _timelineItem(
                          title: 'Work Reviewed',
                          time: 'Today at 9:42 PM',
                          color: Colors.blue,
                          completed: true,
                        ),
                        _timelineItem(
                          title: 'Approval Requested',
                          time: 'Waiting',
                          color: Colors.orange,
                        ),
                        _timelineItem(
                          title: 'Approved',
                          time: 'Waiting',
                          color: Colors.greenAccent,
                        ),
                        _timelineItem(
                          title: 'Invoice Sent',
                          time: 'Waiting',
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 62,
                    child: ElevatedButton.icon(
                      onPressed: _canContinue ? _continue : null,
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(
                        Icons.arrow_forward,
                        size: 28,
                      ),
                      label: Text(
                        selectedApprovalMethod == 'Self Approval'
                            ? 'Approve & Create Invoice'
                            : 'Request Approval',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Nothing will be sent until you press the button above.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
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