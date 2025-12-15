import 'package:flutter/material.dart';
import 'dart:async';

class DriverVideoCallScreen extends StatefulWidget {
  final Map<String, dynamic> driver;

  const DriverVideoCallScreen({
    super.key,
    required this.driver,
  });

  @override
  State<DriverVideoCallScreen> createState() => _DriverVideoCallScreenState();
}

class _DriverVideoCallScreenState extends State<DriverVideoCallScreen> {
  Timer? _callTimer;
  int _callDurationSeconds = 0;
  bool _isVideoOn = true;
  bool _isSpeakerOn = false;
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

  void _toggleVideo() {
    setState(() {
      _isVideoOn = !_isVideoOn;
    });
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

    final pipSize = clampDouble(size.width * 0.3, 100, 140);
    final nameFontSize = clampDouble(size.width * 0.042, 16, 20);
    final durationFontSize = clampDouble(size.width * 0.035, 12, 16);
    final buttonSize = clampDouble(size.width * 0.15, 56, 72);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Stack(
          children: [
            // Main Video Feed (Driver)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[800],
              child: _isVideoOn
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.6,
                            height: size.width * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple[200],
                            ),
                            child: ClipOval(
                              child: Container(
                                color: Colors.purple[200],
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.purple,
                                  size: 120,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
            ),
            // Back Button
            Positioned(
              top: clampDouble(size.height * 0.02, 16, 24),
              left: clampDouble(size.width * 0.05, 16, 24),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Picture-in-Picture (Caller) - Bottom Right
            Positioned(
              bottom: clampDouble(size.height * 0.25, 150, 200),
              right: clampDouble(size.width * 0.05, 16, 24),
              child: Container(
                width: pipSize,
                height: pipSize,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey[300],
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 60,
                          ),
                        ),
                        // Camera Icon (Bottom Right of PIP)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Driver Name and Duration - Bottom Left
            Positioned(
              bottom: clampDouble(size.height * 0.25, 150, 200),
              left: clampDouble(size.width * 0.05, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.driver['name'] ?? 'Theo Holland',
                    style: TextStyle(
                      fontSize: nameFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatDuration(_callDurationSeconds),
                    style: TextStyle(
                      fontSize: durationFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Call Control Buttons - Bottom Center
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
                  SizedBox(width: clampDouble(size.width * 0.04, 12, 20)),
                  // Video Toggle Button
                  _buildCallButton(
                    icon: Icons.videocam,
                    color: Colors.grey[600]!,
                    onPressed: _toggleVideo,
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(width: clampDouble(size.width * 0.04, 12, 20)),
                  // Speaker Toggle Button
                  _buildCallButton(
                    icon: Icons.volume_up,
                    color: Colors.grey[600]!,
                    onPressed: _toggleSpeaker,
                    buttonSize: buttonSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(width: clampDouble(size.width * 0.04, 12, 20)),
                  // Mute Microphone Button
                  _buildCallButton(
                    icon: Icons.mic,
                    color: Colors.grey[600]!,
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
            blurRadius: 10,
            offset: const Offset(0, 3),
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

