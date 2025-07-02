import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/utils/app_snack_bar.dart';
import '../../../bloc/worker_requests_bloc.dart';
import '../../../bloc/worker_requests_state.dart';
import '../../../bloc/worker_requests_event.dart';

class LatestReservationsSection extends StatelessWidget {
  const LatestReservationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkerRequestsBloc, WorkerRequestsState>(
      listener: (context, state) {
        if (state is RequestActionSuccess) {
          AppSnackBar.showSuccess(context, state.message);
        } else if (state is WorkerRequestsError) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "أحدث الطلبات",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: lightColorScheme.scrim,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    // Refresh requests
                    context
                        .read<WorkerRequestsBloc>()
                        .add(const RefreshRequestsEvent());
                  },
                  child: Text(
                    "تحديث",
                    style: TextStyle(
                      color: lightColorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildContent(context, state),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WorkerRequestsState state) {
    if (state is WorkerRequestsLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.h),
          child: CircularProgressIndicator(
            color: lightColorScheme.primary,
          ),
        ),
      );
    }

    if (state is WorkerRequestsLoaded) {
      final requests = state.requests.take(3).toList(); // Show only first 3
      return requests.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final request = requests[index];
                return _buildReservationCard(context, request, state);
              },
            );
    }

    if (state is WorkerRequestsError) {
      return _buildErrorState(context, state.message);
    }

    return _buildEmptyState(context);
  }

  Widget _buildReservationCard(BuildContext context,
      Map<String, dynamic> reservation, WorkerRequestsState state) {
    final String requestId = reservation['id'] ?? '';
    final bool isActionLoading =
        state is RequestActionLoading && state.requestId == requestId;

    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        reservation['customerName'] ?? 'عميل غير محدد',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.scrim,
                                ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: reservation['urgent'] == true
                            ? lightColorScheme.error.withOpacity(0.1)
                            : lightColorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        reservation['urgent'] == true ? "عاجل" : "طلب جديد",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: reservation['urgent'] == true
                                  ? lightColorScheme.error
                                  : lightColorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  context,
                  Icons.home_repair_service,
                  "الخدمة: ${reservation['service'] ?? 'غير محدد'}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.location_on,
                  "الموقع: ${reservation['location'] ?? 'غير محدد'}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.calendar_today,
                  "التاريخ: ${reservation['preferredDate'] ?? 'غير محدد'} - ${reservation['preferredTime'] ?? ''}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.payment,
                  "الميزانية: ${reservation['budget'] ?? 'غير محدد'}",
                ),
                if (reservation['description'] != null) ...[
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    context,
                    Icons.description,
                    "الوصف: ${reservation['description']}",
                  ),
                ],
              ],
            ),
          ),
          Divider(height: 1, color: lightColorScheme.outline),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: isActionLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: lightColorScheme.primary,
                      strokeWidth: 2.w,
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showRejectConfirmation(context, requestId);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: lightColorScheme.error,
                            side: BorderSide(color: lightColorScheme.error),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: const Text("رفض"),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showAcceptConfirmation(context, requestId);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: const Text("قبول"),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void _showAcceptConfirmation(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: lightColorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'قبول الطلب',
                style: TextStyle(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد قبول هذا الطلب؟',
            style: TextStyle(
              color: lightColorScheme.surface,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: lightColorScheme.surface,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context
                    .read<WorkerRequestsBloc>()
                    .add(AcceptRequestEvent(requestId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'قبول',
                style: TextStyle(
                  color: lightColorScheme.onPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectConfirmation(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.cancel,
                color: lightColorScheme.error,
              ),
              SizedBox(width: 8.w),
              Text(
                'رفض الطلب',
                style: TextStyle(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد رفض هذا الطلب؟',
            style: TextStyle(
              color: lightColorScheme.surface,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: lightColorScheme.surface,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context
                    .read<WorkerRequestsBloc>()
                    .add(RejectRequestEvent(requestId));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'رفض',
                style: TextStyle(
                  color: lightColorScheme.onPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.w,
          color: lightColorScheme.primary,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.surface,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48.w,
            color: lightColorScheme.surface,
          ),
          SizedBox(height: 16.h),
          Text(
            "لا توجد طلبات جديدة",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: lightColorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "ستظهر هنا الطلبات الجديدة عندما يقوم العملاء بحجز خدماتك",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.surface,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: lightColorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            "حدث خطأ",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: lightColorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.surface,
                ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context
                  .read<WorkerRequestsBloc>()
                  .add(const GetMyWorkRequestsEvent());
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
