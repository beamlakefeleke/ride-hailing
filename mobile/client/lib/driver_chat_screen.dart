import 'package:flutter/material.dart';
import 'driver_voice_call_screen.dart';
import 'driver_video_call_screen.dart';

class DriverChatScreen extends StatefulWidget {
  final Map<String, dynamic> driver;

  const DriverChatScreen({
    super.key,
    required this.driver,
  });

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello, good morning Andrew',
      'isDriver': true,
      'timestamp': '09:41',
    },
    {
      'text': 'I\'m Theo. I\'m on my way to your location. Please wait... ⏳😊',
      'isDriver': true,
      'timestamp': '09:41',
    },
    {
      'text': 'Hello Theo, ok I will be waiting for you in front of Bobst Library. You can contact me as soon as possible when you arrive 😊',
      'isDriver': false,
      'timestamp': '09:41',
    },
    {
      'type': 'images',
      'images': [
        'https://via.placeholder.com/150?text=Bobst+Library+1',
        'https://via.placeholder.com/150?text=Bobst+Library+2',
      ],
    },
    {
      'text': 'Great! I\'ll be there in less than 1 minute 🔥',
      'isDriver': true,
      'timestamp': '09:41',
    },
    {
      'text': 'Okay! Great 👍',
      'isDriver': false,
      'timestamp': '09:41',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isDriver': false,
        'timestamp': _getCurrentTime(),
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double clampDouble(double value, double min, double max) =>
        value.clamp(min, max).toDouble();

    final horizontalPadding = clampDouble(size.width * 0.05, 16, 24);
    final titleFontSize = clampDouble(size.width * 0.042, 14, 16);
    final messageFontSize = clampDouble(size.width * 0.038, 13, 15);
    final timestampFontSize = clampDouble(size.width * 0.03, 10, 12);
    final inputFontSize = clampDouble(size.width * 0.038, 13, 15);
    final iconSize = clampDouble(size.width * 0.06, 22, 28);
    final spacing = clampDouble(size.height * 0.01, 8, 12);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(size, clampDouble, titleFontSize, iconSize),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message['type'] == 'images') {
                  return _buildImageMessage(size, clampDouble, spacing);
                }
                return _buildMessageBubble(
                  message['text'] as String,
                  message['isDriver'] as bool,
                  message['timestamp'] as String,
                  messageFontSize,
                  timestampFontSize,
                  spacing,
                );
              },
            ),
          ),
          // Input Bar
          _buildInputBar(
            size,
            clampDouble,
            inputFontSize,
            iconSize,
            horizontalPadding,
            spacing,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    Size size,
    Function clampDouble,
    double titleFontSize,
    double iconSize,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.driver['name'] ?? 'Theo Holland',
        style: TextStyle(
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: [
        // Phone Call Icon
        IconButton(
          icon: Icon(Icons.phone, size: iconSize, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DriverVoiceCallScreen(driver: widget.driver),
              ),
            );
          },
        ),
        // Video Call Icon
        IconButton(
          icon: Icon(Icons.videocam, size: iconSize, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DriverVideoCallScreen(driver: widget.driver),
              ),
            );
          },
        ),
        SizedBox(width: clampDouble(size.width * 0.02, 4, 8)),
      ],
    );
  }

  Widget _buildMessageBubble(
    String text,
    bool isDriver,
    String timestamp,
    double messageFontSize,
    double timestampFontSize,
    double spacing,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Row(
        mainAxisAlignment:
            isDriver ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isDriver) ...[
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 1.5,
                  vertical: spacing,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: messageFontSize,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: timestampFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: spacing * 2),
          ] else ...[
            SizedBox(width: spacing * 2),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 1.5,
                  vertical: spacing,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: messageFontSize,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: timestampFontSize,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage(Size size, Function clampDouble, double spacing) {
    final imageSize = clampDouble(size.width * 0.4, 120, 180);
    final borderRadius = clampDouble(size.width * 0.03, 8, 12);

    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First Image
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 40, color: Colors.grey[400]),
                    SizedBox(height: 8),
                    Text(
                      'Bobst Library',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
          // Second Image
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 40, color: Colors.grey[400]),
                    SizedBox(height: 8),
                    Text(
                      'Bobst Library',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(
    Size size,
    Function clampDouble,
    double inputFontSize,
    double iconSize,
    double horizontalPadding,
    double spacing,
  ) {
    final borderRadius = clampDouble(size.width * 0.04, 12, 16);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: spacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Emoji Icon
            IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                size: iconSize,
                color: Colors.grey[600],
              ),
              onPressed: () {
                // Handle emoji picker
              },
            ),
            // Text Input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(borderRadius * 2),
                ),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(fontSize: inputFontSize),
                  decoration: InputDecoration(
                    hintText: 'Send a message...',
                    hintStyle: TextStyle(
                      fontSize: inputFontSize,
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing * 1.5,
                      vertical: spacing,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: spacing * 0.5),
            // Attachment Icon
            IconButton(
              icon: Icon(
                Icons.attach_file,
                size: iconSize,
                color: Colors.grey[600],
              ),
              onPressed: () {
                // Handle file attachment
              },
            ),
            // Send Button
            Container(
              width: clampDouble(size.width * 0.12, 44, 52),
              height: clampDouble(size.width * 0.12, 44, 52),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

