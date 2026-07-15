import 'dart:async';
import 'package:flutter/material.dart';

import 'review_work_screen.dart';
class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({super.key});

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> {
  Timer? recordingTimer;

  int elapsedSeconds = 0;
  bool isRecording = false;
  bool isPaused = false;

  final TextEditingController transcriptionController =
      TextEditingController();

  @override
  void dispose() {
    recordingTimer?.cancel();
    transcriptionController.dispose();
    super.dispose();
  }

  void _startRecording() {
    recordingTimer?.cancel();

    setState(() {
      isRecording = true;
      isPaused = false;
    });

    recordingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!isPaused) {
          setState(() {
            elapsedSeconds++;
          });
        }
      },
    );
  }

  void _pauseOrResume() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _finishRecording() {
    recordingTimer?.cancel();

    setState(() {
      isRecording = false;
      isPaused = false;
    });
  }

  void _cancelRecording() {
    recordingTimer?.cancel();

    setState(() {
      elapsedSeconds = 0;
      isRecording = false;
      isPaused = false;
      transcriptionController.clear();
    });

    Navigator.pop(context);
  }

  String _formatTime() {
    final int minutes = elapsedSeconds ~/ 60;
    final int seconds = elapsedSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  void _reviewWork() {
    _finishRecording();
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ReviewWorkScreen(),
  ),
);
}
    

  Widget _waveform() {
    final List<double> heights = [
      18,
      30,
      44,
      64,
      38,
      24,
      52,
      76,
      48,
      28,
      62,
      42,
      22,
      36,
      70,
      50,
      30,
      56,
      80,
      46,
      26,
      60,
      38,
      20,
    ];

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: heights.map((height) {
          double displayedHeight = height * 0.35;

          if (isRecording && !isPaused) {
            displayedHeight = height;
          } else if (isPaused) {
            displayedHeight = height * 0.55;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 5,
            height: displayedHeight,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isPaused ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: isPaused ? Colors.orange : Colors.blue,
                  blurRadius: isRecording ? 8 : 2,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = !isRecording
        ? 'Ready to listen'
        : isPaused
            ? 'Recording paused'
            : 'Listening...';

    final Color statusColor = !isRecording
        ? Colors.white70
        : isPaused
            ? Colors.orange
            : Colors.lightGreenAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _cancelRecording,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Tell Me What You Did',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatTime(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _waveform(),
                  const SizedBox(height: 24),
                  Center(
                    child: InkWell(
                      onTap: isRecording
                          ? _pauseOrResume
                          : _startRecording,
                      borderRadius: BorderRadius.circular(80),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 145,
                        height: 145,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPaused
                              ? Colors.orange.withValues(alpha: 0.20)
                              : Colors.blue.withValues(alpha: 0.22),
                          border: Border.all(
                            color:
                                isPaused ? Colors.orange : Colors.blue,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isPaused
                                  ? Colors.orange
                                  : Colors.blue,
                              blurRadius: isRecording ? 28 : 12,
                            ),
                          ],
                        ),
                        child: Icon(
                          !isRecording
                              ? Icons.mic
                              : isPaused
                                  ? Icons.play_arrow
                                  : Icons.pause,
                          color: Colors.white,
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    !isRecording
                        ? 'Tap to start speaking'
                        : isPaused
                            ? 'Tap to resume'
                            : 'Tap to pause',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 34),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101824),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.notes,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Live Transcription',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: transcriptionController,
                          minLines: 7,
                          maxLines: 12,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'What you say will appear here. You can also type or make corrections.',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              height: 1.5,
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
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 58,
                          child: OutlinedButton.icon(
                            onPressed: _cancelRecording,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              side: const BorderSide(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: transcriptionController.text
                                        .trim()
                                        .isEmpty &&
                                    elapsedSeconds == 0
                                ? null
                                : _reviewWork,
                            icon: const Icon(Icons.fact_check_outlined),
                            label: const Text(
                              'Review My Work',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Nothing will be sent to a customer until you review and approve it.',
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