import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class ChatMessagesSection extends StatelessWidget {
  final String customerId;

  const ChatMessagesSection({
    Key? key,
    required this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock chat data - in a real app this would come from a repository
    final List<Map<String, dynamic>> messages = [
      {
        'id': '1',
        'sender': 'customer',
        'text': 'السلام عليكم، أحتاج إلى خدمة سباكة في منزلي',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      },
      {
        'id': '2',
        'sender': 'worker',
        'text': 'وعليكم السلام، أنا متاح. ما هي المشكلة التي تواجهك؟',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      },
      {
        'id': '3',
        'sender': 'customer',
        'text': 'عندي تسريب في الحمام ويحتاج إلى إصلاح عاجل',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'id': '4',
        'sender': 'worker',
        'text':
            'حسناً، يمكنني الحضور غداً في الساعة 10 صباحاً. هل هذا مناسب لك؟',
        'timestamp': DateTime.now().subtract(const Duration(hours: 23)),
      },
      {
        'id': '5',
        'sender': 'customer',
        'text': 'نعم، هذا مناسب. شكراً لك',
        'timestamp': DateTime.now().subtract(const Duration(hours: 22)),
      },
      {
        'id': '6',
        'sender': 'worker',
        'text':
            'عظيم، سأكون هناك في الموعد المحدد. هل يمكنك إرسال العنوان بالتفصيل؟',
        'timestamp': DateTime.now().subtract(const Duration(hours: 21)),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.onSecondary.withOpacity(0.5),
      ),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        reverse: true, // Display most recent messages at the bottom
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message =
              messages[messages.length - 1 - index]; // Reverse order
          final bool isMe = message['sender'] == 'worker';

          return _buildMessageBubble(
            context,
            message['text'],
            isMe,
            message['timestamp'],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    String message,
    bool isMe,
    DateTime timestamp,
  ) {
    final timeString = _formatTime(timestamp);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildTimeText(context, timeString),
          Container(
            constraints: BoxConstraints(
              maxWidth: 0.7.sw,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isMe ? lightColorScheme.primary : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                bottomRight:
                    isMe ? Radius.circular(4.r) : Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isMe ? Colors.white : Colors.black,
                  ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
          if (isMe) _buildTimeText(context, timeString),
        ],
      ),
    );
  }

  Widget _buildTimeText(BuildContext context, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        time,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: lightColorScheme.surface,
              fontSize: 10.sp,
            ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String timeStr =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (messageDate == today) {
      return 'اليوم $timeStr';
    } else if (messageDate == yesterday) {
      return 'أمس $timeStr';
    } else {
      return '${dateTime.day}/${dateTime.month} $timeStr';
    }
  }
}
