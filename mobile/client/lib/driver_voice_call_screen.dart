import 'package:flutter/material.dart';
import 'dart:async';

class DriverVoiceCallScreen extends StatefulWidget {
  final Map<String, dynamic> driver;

  const DriverVoiceCallScreen({
    super.key,
    required this.driver,
  });

  @override
  State<DriverVoiceCallScreen> createState() => _DriverVoiceCallScreenState();
}

class _DriverVoiceCallScreenState extends State<DriverVoiceCallScreen> {
  Timer? _callTimer;
  int _callDurationSeconds = 0;
  bool _isSpeakerOn = true;
  bool _isMicrophoneOn = true;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDurationSeconds++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')} mins';
  }

  void _endCall() {
    _callTimer?.cancel();
    Navigator.of(context).pop();
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleMicrophone() {
    setState(() {
      _isMicrophoneOn = !_isMicrophoneOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final profileSize = clampDouble(size.width * 0.4, 150, 220);
    final nameFontSize = clampDouble(size.width * 0.06, 24, 32);
    final durationFontSize = clampDouble(size.width * 0.038, 14, 18);
    final buttonSize = clampDouble(size.width * 0.18, 64, 80);
    final iconSize = clampDouble(size.width * 0.08, 28, 36);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[100]!,
              Colors.blue[200]!,
              Colors.green[300]!,
              Colors.green[400]!,
              Colors.blue[600]!,
              Colors.blue[800]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button
              Positioned(
                top: clampDouble(size.height * 0.02, 16, 24),
                left: clampDouble(size.width * 0.05, 16, 24),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Main Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Picture
                    Container(
                      width: profileSize,
                      height: profileSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple[200],
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Container(
                          color: Colors.purple[200],
                          child: const Icon(
                            Icons.person,
                            color: Colors.purple,
                            size: 100,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: clampDouble(size.height * 0.04, 24, 40)),
                    // Driver Name
                    Text(
                      widget.driver['name'] ?? 'Theo Holland',
                      style: TextStyle(
                        fontSize: nameFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: clampDouble(size.height * 0.02, 12, 20)),
                    // Call Duration
                    Text(
                      _formatDuration(_callDurationSeconds),
                      style: TextStyle(
                        fontSize: durationFontSize,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Call Control Buttons
              Positioned(
                bottom: clampDouble(size.height * 0.08, 60, 100),
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // End Call Button
                    _buildCallButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      onPressed: _endCall,
                      buttonSize: buttonSize,
                      iconSize: iconSize,
                    ),
                    SizedBox(width: clampDouble(size.width * 0.08, 24, 40)),
                    // Speaker Button
                    _buildCallButton(
                      icon: Icons.volume_up,
                      color: _isSpeakerOn ? Colors.blue[300]! : Colors.grey[400]!,
                      onPressed: _toggleSpeaker,
                      buttonSize: buttonSize,
                      iconSize: iconSize,
                    ),
                    SizedBox(width: clampDouble(size.width * 0.08, 24, 40)),
                    // Microphone Button
                    _buildCallButton(
                      icon: Icons.mic,
                      color: _isMicrophoneOn ? Colors.blue[300]! : Colors.grey[400]!,
                      onPressed: _toggleMicrophone,
                      buttonSize: buttonSize,
                      iconSize: iconSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required double buttonSize,
    required double iconSize,
  }) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: iconSize),
        onPressed: onPressed,
      ),
    );
  }
}

