import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInputWidget({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _messageController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    widget.onSendMessage(text.trim());
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: lightColorScheme.primary,
              size: 24.w,
            ),
            onPressed: () {
              // Handle attachments
            },
          ),

          // Text input field
          Expanded(
            child: TextField(
              controller: _messageController,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "اكتب رسالتك هنا...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                filled: true,
                fillColor: lightColorScheme.onSecondary,
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.trim().isNotEmpty;
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
            ),
          ),

          // Send button
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isComposing
                  ? lightColorScheme.primary
                  : lightColorScheme.surface,
              size: 24.w,
            ),
            onPressed: _isComposing
                ? () => _handleSubmitted(_messageController.text)
                : null,
          ),
        ],
      ),
    );
  }
}
