import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../theme/color/app_theme.dart';
import '../../../../../core/services/user_data_service.dart';
import '../../../../../core/storage/token_storage.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../chat_page/chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<Map<String, dynamic>> chatSessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatSessions();
  }

  Future<void> _loadChatSessions() async {
    try {
      final tokenStorage = di.sl<TokenStorage>();
      final userId = await tokenStorage.getUserId();

      if (userId != null) {
        final sessions = UserDataService.generateChatSessions(userId);
        setState(() {
          chatSessions = sessions;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
              child: ListView.builder(
                itemCount: chatSessions.length,
                itemBuilder: (context, index) {
                  final session = chatSessions[index];
                  return _buildChatListItem(context, session);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListItem(
      BuildContext context, Map<String, dynamic> session) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              workerName: session['workerName'],
              profession: session['profession'],
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
                session['workerName'][0],
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
                        session['workerName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: lightColorScheme.scrim,
                        ),
                      ),
                      Text(
                        session['time'],
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
                        session['profession'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (session['hasUnread'])
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
                    session['lastMessage'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: session['hasUnread']
                          ? lightColorScheme.scrim
                          : lightColorScheme.surface,
                      fontWeight: session['hasUnread']
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
}
