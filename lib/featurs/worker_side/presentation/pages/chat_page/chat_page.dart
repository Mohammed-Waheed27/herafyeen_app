import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class WorkerChatPage extends StatefulWidget {
  // Required parameters for the chat page
  final String customerId;
  final String customerName;
  final String customerImage;

  const WorkerChatPage({
    Key? key,
    required this.customerId,
    required this.customerName,
    required this.customerImage,
  }) : super(key: key);

  // Constructor for demonstration purposes with default values
  WorkerChatPage.demo({Key? key})
      : customerId = '1',
        customerName = 'أحمد محمد',
        customerImage = 'assets/images/placeholder.png',
        super(key: key);

  @override
  State<WorkerChatPage> createState() => _WorkerChatPageState();
}

class _WorkerChatPageState extends State<WorkerChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock message data for demonstration
  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    // Initialize with mock messages
    _messages = [
      Message(
        text: 'أحتاج إلى مساعدة في إصلاح الصنبور',
        isMe: false,
        time: '10:30',
      ),
      Message(
        text: 'بالتأكيد، يمكنني مساعدتك. متى تفضل أن أحضر؟',
        isMe: true,
        time: '10:31',
      ),
      Message(
        text: 'هل يمكنك الحضور غدا؟',
        isMe: false,
        time: '10:32',
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        Message(
          text: _messageController.text.trim(),
          isMe: true,
          time: '${DateTime.now().hour}:${DateTime.now().minute}',
        ),
      );
      _messageController.clear();
    });

    // Scroll to bottom after sending message
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate reply after 1 second (for demo)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          Message(
            text: 'شكراً للرد، سأكون في انتظارك',
            isMe: false,
            time: '${DateTime.now().hour}:${DateTime.now().minute}',
          ),
        );
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onSecondary,
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: lightColorScheme.onPrimary,
              child: Text(
                widget.customerName[0],
                style: TextStyle(
                  color: lightColorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customerName,
                  style: TextStyle(
                    color: lightColorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'طلب خدمة',
                  style: TextStyle(
                    color: lightColorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Show customer details
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat messages area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.r),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Message input area
            Container(
              padding: EdgeInsets.all(8.r),
              color: lightColorScheme.onPrimary,
              child: Row(
                children: [
                  // Add attachment button
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: lightColorScheme.primary,
                    ),
                    onPressed: () {
                      // Attachment functionality
                    },
                  ),

                  // Message text field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالتك هنا...',
                        hintTextDirection: TextDirection.rtl,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: lightColorScheme.onSecondary,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),

                  // Send button
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: lightColorScheme.primary,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8.h,
          left: message.isMe ? 0 : 64.w,
          right: message.isMe ? 64.w : 0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: message.isMe
              ? lightColorScheme.primary
              : lightColorScheme.onPrimary,
          borderRadius: BorderRadius.circular(16.r).copyWith(
            bottomLeft: message.isMe ? Radius.zero : null,
            bottomRight: message.isMe ? null : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isMe
                    ? lightColorScheme.onPrimary
                    : lightColorScheme.scrim,
                fontSize: 14.sp,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 4.h),
            Text(
              message.time,
              style: TextStyle(
                color: message.isMe
                    ? lightColorScheme.onPrimary.withOpacity(0.7)
                    : lightColorScheme.surface,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  final String time;

  Message({
    required this.text,
    required this.isMe,
    required this.time,
  });
}
