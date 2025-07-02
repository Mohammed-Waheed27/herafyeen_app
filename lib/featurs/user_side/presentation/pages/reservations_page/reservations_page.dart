import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../theme/color/app_theme.dart';
import '../../../../../core/services/user_data_service.dart';
import '../../../../../core/storage/token_storage.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../chat_page/chat_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  List<Map<String, dynamic>> reservations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final tokenStorage = di.sl<TokenStorage>();
      final userId = await tokenStorage.getUserId();

      if (userId != null) {
        final userReservations = UserDataService.generateReservations(userId);
        setState(() {
          reservations = userReservations;
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
          actions: [],
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: lightColorScheme.onPrimary,
          elevation: 0,
          title: Text(
            'الحجوزات',
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
        actions: [],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        title: Text(
          'الحجوزات',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: lightColorScheme.scrim,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                "حجوزاتك",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: lightColorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = reservations[index];
                    final status = reservation['status'];

                    Color statusColor;
                    String statusText;

                    if (status == 'accepted') {
                      statusColor = lightColorScheme.tertiary;
                      statusText = 'تم القبول';
                    } else if (status == 'pending') {
                      statusColor = Colors.amber;
                      statusText = 'قيد الإنتظار';
                    } else {
                      statusColor = lightColorScheme.error;
                      statusText = 'تم الرفض';
                    }

                    return Card(
                      color: lightColorScheme.onSecondary,
                      margin: EdgeInsets.only(bottom: 12.h),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  reservation['workerName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: lightColorScheme.scrim,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              reservation['profession'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: lightColorScheme.secondary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'تاريخ الحجز: ${reservation['date']}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: lightColorScheme.surface,
                              ),
                            ),
                            if (status == 'accepted') ...[
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to chat page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          workerName: reservation['workerName'],
                                          profession: reservation['profession'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.chat,
                                    color: lightColorScheme.onPrimary,
                                  ),
                                  label: Text(
                                    'دردشة',
                                    style: TextStyle(
                                      color: lightColorScheme.onPrimary,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: lightColorScheme.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
