import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/services/user_data_service.dart';
import '../../../../../../core/models/user_model.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate consistent data for "mena" worker
    final workerData = UserDataService.generateUserData(
        'mena', 'mena@example.com', UserRole.worker);

    // Mock additional stats - in a real app this would come from a repository
    final double rating = 4.8;
    final int completedJobs = 126;
    final String workerImage = "assets/images/placeholder.png";

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: lightColorScheme.primary.withOpacity(0.1),
                backgroundImage: AssetImage(workerImage),
                onBackgroundImageError: (_, __) {
                  // Handle error loading image
                },
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: lightColorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.w,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16.w,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          workerData.fullName ?? 'غير محدد',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 4.h),
        Text(
          workerData.jobTitle ?? 'حرفي',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: lightColorScheme.surface,
              ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusItem(
              context,
              "$rating",
              "التقييم",
              Icons.star,
              lightColorScheme.primary,
            ),
            Container(
              height: 40.h,
              width: 1,
              color: lightColorScheme.outline,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
            ),
            _buildStatusItem(
              context,
              "$completedJobs",
              "الأعمال المكتملة",
              Icons.work,
              lightColorScheme.tertiary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20.w,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: lightColorScheme.surface,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
