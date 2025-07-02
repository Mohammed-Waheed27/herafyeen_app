import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/services/user_data_service.dart';
import '../../../../../../core/models/user_model.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate consistent data for "mena" worker
    final workerData = UserDataService.generateUserData(
        'mena', 'mena@example.com', UserRole.worker);

    // Generate additional bio information
    final String workerBio =
        'حرفي ${workerData.jobTitle} محترف متخصص في جميع أعمال ${workerData.jobTitle}. خبرة واسعة في التركيبات والإصلاحات المنزلية. أقدم خدمات عالية الجودة بأسعار مناسبة مع ضمان على جميع الأعمال. متاح للعمل في جميع أنحاء ${workerData.location?.split(' - ').first ?? 'المنطقة'}.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "معلومات شخصية"),
        SizedBox(height: 16.h),
        _buildInfoCard(context, [
          _buildInfoItem(context, "سنوات الخبرة", "5 سنوات", Icons.work),
          _buildDivider(),
          _buildInfoItem(context, "رقم الهاتف", workerData.phone ?? 'غير محدد',
              Icons.phone),
          _buildDivider(),
          _buildInfoItem(context, "الموقع", workerData.location ?? 'غير محدد',
              Icons.location_on),
          _buildDivider(),
          _buildInfoItem(context, "ساعات العمل",
              workerData.workingHours ?? 'غير محدد', Icons.access_time),
        ]),
        SizedBox(height: 24.h),
        _buildSectionTitle(context, "نبذة عني"),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
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
          child: Text(
            workerBio,
            style: Theme.of(context).textTheme.bodyMedium,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      width: double.infinity,
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
        children: children,
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: lightColorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: lightColorScheme.primary,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: lightColorScheme.surface,
                      ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: lightColorScheme.outline.withOpacity(0.5),
    );
  }
}
