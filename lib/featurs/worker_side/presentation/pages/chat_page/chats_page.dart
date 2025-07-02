import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import 'chat_page.dart';

class WorkerChatsPage extends StatelessWidget {
  const WorkerChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final List<Map<String, dynamic>> customers = [
      {
        'id': '1',
        'name': 'أحمد محمود',
        'lastMessage': 'أحتاج إلى مساعدة في إصلاح الصنبور',
        'time': '10:30',
        'hasUnread': true,
        'order': 'إصلاح صنبور',
      },
      {
        'id': '2',
        'name': 'محمد علي',
        'lastMessage': 'متى ستصل؟',
        'time': 'أمس',
        'hasUnread': false,
        'order': 'تركيب غسالة',
      },
      {
        'id': '3',
        'name': 'خالد أحمد',
        'lastMessage': 'شكراً للعمل الرائع',
        'time': 'الأحد',
        'hasUnread': false,
        'order': 'إصلاح تسرب مياه',
      },
    ];

    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'المحادثات',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: lightColorScheme.scrim,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                "الرسائل",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: lightColorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
              ),
            ),
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث...',
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    Icons.search,
                    color: lightColorScheme.surface,
                  ),
                  filled: true,
                  fillColor: lightColorScheme.onSurface,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: customers.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        final customer = customers[index];
                        return _buildChatListItem(context, customer);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListItem(
      BuildContext context, Map<String, dynamic> customer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkerChatPage(
              customerId: customer['id'],
              customerName: customer['name'],
              customerImage: 'assets/images/placeholder.png',
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: lightColorScheme.outline,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Profile picture
            CircleAvatar(
              radius: 24.r,
              backgroundColor: lightColorScheme.primaryContainer,
              child: Text(
                customer['name'][0],
                style: TextStyle(
                  color: lightColorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Chat details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: lightColorScheme.scrim,
                        ),
                      ),
                      Text(
                        customer['time'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: lightColorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer['order'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (customer['hasUnread'])
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: lightColorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: lightColorScheme.onPrimary,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    customer['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: customer['hasUnread']
                          ? lightColorScheme.scrim
                          : lightColorScheme.surface,
                      fontWeight: customer['hasUnread']
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.w,
            color: lightColorScheme.surface,
          ),
          SizedBox(height: 16.h),
          Text(
            "لا توجد محادثات",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "سيظهر هنا محادثاتك مع العملاء بمجرد قبول طلباتهم",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.surface,
                ),
          ),
        ],
      ),
    );
  }
}
