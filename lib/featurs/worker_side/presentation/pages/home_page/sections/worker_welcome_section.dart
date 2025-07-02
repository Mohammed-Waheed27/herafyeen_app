import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/services/user_data_service.dart';
import '../../../../../../core/models/user_model.dart';

class WorkerWelcomeSection extends StatelessWidget {
  const WorkerWelcomeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate consistent data for "mena" worker
    final workerData = UserDataService.generateUserData(
        'mena', 'mena@example.com', UserRole.worker);

    final String workerFirstName =
        workerData.fullName?.split(' ').first ?? 'العامل';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: lightColorScheme.onSecondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "مرحباً، $workerFirstName",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.scrim,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "خدمة: ${workerData.jobTitle ?? 'حرفي'}",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: lightColorScheme.surface,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildStatCard(
                context,
                "5",
                "طلبات جديدة",
                lightColorScheme.primary,
              ),
              SizedBox(width: 12.w),
              _buildStatCard(
                context,
                "12",
                "طلبات مكتملة",
                lightColorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String number, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
