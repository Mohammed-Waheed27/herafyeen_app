import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class ReservationHistorySection extends StatelessWidget {
  final String statusFilter;

  const ReservationHistorySection({
    Key? key,
    required this.statusFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock reservation history data - in a real app this would come from a repository
    final List<Map<String, dynamic>> allReservations = [
      {
        'id': '1',
        'customerName': 'أحمد محمد',
        'service': 'إصلاح حنفية',
        'location': 'طنطا - شارع البحر',
        'date': '10 مايو 2025',
        'time': '2:30 مساءً',
        'status': 'completed',
        'payment': '150 جنيه',
        'rating': 5,
      },
      {
        'id': '2',
        'customerName': 'سمير علي',
        'service': 'تركيب مواسير جديدة',
        'location': 'المنصورة - شارع الجامعة',
        'date': '8 مايو 2025',
        'time': '10:00 صباحاً',
        'status': 'cancelled',
        'payment': '0 جنيه',
        'rating': 0,
      },
      {
        'id': '3',
        'customerName': 'محمد خالد',
        'service': 'إصلاح تسرب',
        'location': 'ميت غمر - شارع الجلاء',
        'date': '5 مايو 2025',
        'time': '4:00 مساءً',
        'status': 'completed',
        'payment': '200 جنيه',
        'rating': 4,
      },
      {
        'id': '4',
        'customerName': 'فاطمة أحمد',
        'service': 'تركيب سخان',
        'location': 'الدقهلية - مدينة السنبلاوين',
        'date': '2 مايو 2025',
        'time': '1:00 مساءً',
        'status': 'completed',
        'payment': '300 جنيه',
        'rating': 5,
      },
      {
        'id': '5',
        'customerName': 'عمر محمود',
        'service': 'إصلاح تسريب في المطبخ',
        'location': 'المنصورة - حي الجامعة',
        'date': '1 مايو 2025',
        'time': '11:00 صباحاً',
        'status': 'cancelled',
        'payment': '0 جنيه',
        'rating': 0,
      },
    ];

    // Filter reservations based on status
    final List<Map<String, dynamic>> filteredReservations =
        statusFilter == 'all'
            ? allReservations
            : allReservations
                .where((res) => res['status'] == statusFilter)
                .toList();

    return filteredReservations.isEmpty
        ? _buildEmptyState(context)
        : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            itemCount: filteredReservations.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final reservation = filteredReservations[index];
              return _buildReservationCard(context, reservation);
            },
          );
  }

  Widget _buildReservationCard(
      BuildContext context, Map<String, dynamic> reservation) {
    final bool isCompleted = reservation['status'] == 'completed';
    final Color statusColor =
        isCompleted ? lightColorScheme.tertiary : lightColorScheme.error;
    final String statusText = isCompleted ? "مكتملة" : "ملغية";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                    Text(
                      reservation['customerName'],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: statusColor,
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
                  "الخدمة: ${reservation['service']}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.location_on,
                  "الموقع: ${reservation['location']}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.calendar_today,
                  "التاريخ: ${reservation['date']} - ${reservation['time']}",
                ),
                SizedBox(height: 8.h),
                _buildInfoRow(
                  context,
                  Icons.payment,
                  "المبلغ: ${reservation['payment']}",
                ),
                if (isCompleted) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "التقييم: ${reservation['rating']}/5",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
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
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;

    switch (statusFilter) {
      case 'completed':
        message = "لا توجد طلبات مكتملة في سجلك";
        icon = Icons.task_alt;
        break;
      case 'cancelled':
        message = "لا توجد طلبات ملغية في سجلك";
        icon = Icons.cancel;
        break;
      default:
        message = "لا توجد طلبات في سجلك";
        icon = Icons.history;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.w,
              color: lightColorScheme.surface,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: lightColorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "ستظهر هنا الطلبات التي قمت بإتمامها أو إلغاءها",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: lightColorScheme.surface,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
