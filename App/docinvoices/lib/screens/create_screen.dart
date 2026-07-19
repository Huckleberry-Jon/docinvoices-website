import 'package:flutter/material.dart';
import 'voice_capture_screen.dart';
class CreateScreen extends StatefulWidget {
  const CreateScreen({
  super.key,
  this.customerName = '',
  this.equipment = '',
  this.unitNumber = '',
  this.vin = '',
  this.mileage = '',
  this.poNumber = '',
  this.completedDate = '',
});

  final String customerName;
  final String equipment;
  final String unitNumber;
  final String vin;
  final String mileage;
final String poNumber;
final String completedDate;

  @override
  State<CreateScreen> createState() => _CreateScreenState();
} 
  

class _CreateScreenState extends State<CreateScreen> {
  bool isListening = false;

  void _openVoiceCapture() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VoiceCaptureScreen(
        customerName: widget.customerName,
        equipment: widget.equipment,
        unitNumber: widget.unitNumber,
        vin: widget.vin,
        mileage: widget.mileage,
poNumber: widget.poNumber,
completedDate: widget.completedDate,
      ),
    ),
  );
}

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be connected next.'),
      ),
    );
  }

  Widget _createOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: title == 'New Job'
    ? _openVoiceCapture
    : () => _showComingSoon(title),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.55),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.22),
                  border: Border.all(
                    color: accentColor,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 34,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.white70,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _waveform() {
    final heights = <double>[
      8,
      12,
      18,
      28,
      42,
      56,
      35,
      22,
      12,
      18,
      34,
      54,
      72,
      44,
      24,
      14,
      20,
      38,
      60,
      78,
      52,
      30,
      18,
      12,
      22,
      42,
      64,
      48,
      28,
      18,
      10,
    ];

    return SizedBox(
      height: 96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: heights.map((height) {
          final double adjustedHeight =
              isListening ? height : height * 0.55;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 4,
            height: adjustedHeight,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.blue,
                  blurRadius: 8,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _benefit({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _showComingSoon(label),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 30,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                _showComingSoon('Help');
                              },
                              icon: const Icon(
                                Icons.help_outline,
                                color: Colors.white70,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'Doc',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Invoices',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'What would you like to create?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Choose an option below or just tap the microphone.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _createOption(
                          title: 'New Job',
                          subtitle: 'Create a new job or work order.',
                          icon: Icons.local_shipping_outlined,
                          accentColor: Colors.blue,
                        ),
                        _createOption(
                          title: 'Estimate',
                          subtitle: 'Create an estimate for a customer.',
                          icon: Icons.request_quote_outlined,
                          accentColor: Colors.orange,
                        ),
                        _createOption(
                          title: 'Customer',
                          subtitle: 'Add a new customer to your list.',
                          icon: Icons.person_outline,
                          accentColor: Colors.lightGreen,
                        ),
                        _createOption(
                          title: 'Reminder',
                          subtitle: 'Create a reminder or follow-up task.',
                          icon: Icons.calendar_month_outlined,
                          accentColor: Colors.purpleAccent,
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF07111D),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '✨ Tell me what you need.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isListening
                                    ? 'Listening... Speak naturally.'
                                    : 'Just tap the microphone and start talking.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isListening
                                      ? Colors.lightGreenAccent
                                      : Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  _waveform(),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(60),
                                    onTap: _openVoiceCapture,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      width: 112,
                                      height: 112,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isListening
                                            ? Colors.red.withValues(alpha: 0.25)
                                            : Colors.blue.withValues(alpha: 0.25),
                                        border: Border.all(
                                          color: isListening
                                              ? Colors.redAccent
                                              : Colors.blue,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: isListening
                                                ? Colors.redAccent
                                                : Colors.blue,
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isListening ? Icons.stop : Icons.mic,
                                        color: Colors.white,
                                        size: 58,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isListening
                                    ? 'Tap to finish'
                                    : 'Tap the microphone to begin',
                                style: TextStyle(
                                  color: isListening
                                      ? Colors.redAccent
                                      : Colors.blue,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 26),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _benefit(
                                    icon: Icons.bolt,
                                    title: 'Fast',
                                    subtitle: 'Create in seconds',
                                    color: Colors.blue,
                                  ),
                                  _benefit(
                                    icon: Icons.track_changes,
                                    title: 'Smart',
                                    subtitle: 'Captures key details',
                                    color: Colors.orange,
                                  ),
                                  _benefit(
                                    icon: Icons.shield_outlined,
                                    title: 'Secure',
                                    subtitle: 'Your data is protected',
                                    color: Colors.lightGreen,
                                  ),
                                  _benefit(
                                    icon: Icons.check_circle_outline,
                                    title: 'Simple',
                                    subtitle: 'Just talk naturally',
                                    color: Colors.purpleAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF07111D),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '💡 Try saying...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '• “Oil change on Unit 42”\n'
                                '• “Create estimate for fence repair”\n'
                                '• “Add customer Mike Smith”\n'
                                '• “Remind me to call John Friday”',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF07111D),
                border: Border(
                  top: BorderSide(color: Colors.white12),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _bottomItem(
                      icon: Icons.attach_money,
                      label: 'Payments',
                      color: Colors.lightGreen,
                    ),
                    _bottomItem(
                      icon: Icons.description_outlined,
                      label: 'Estimates',
                      color: Colors.orange,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 62,
                              height: 62,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/docinvoices_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Create',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _bottomItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'Invoices',
                      color: Colors.purpleAccent,
                    ),
                    _bottomItem(
                      icon: Icons.bar_chart,
                      label: 'Reports',
                      color: Colors.lightGreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}