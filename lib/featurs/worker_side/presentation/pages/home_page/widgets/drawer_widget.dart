import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../../core/services/user_data_service.dart';
import '../../../../../../core/models/user_model.dart';
import '../../../../../../core/di/injection_container.dart' as di;
import '../../../../../../core/utils/app_snack_bar.dart';
import '../../../../../user_side/presentation/bloc/profile_bloc.dart';
import '../../requests_page/worker_requests_page.dart';

class WorkerDrawerWidget extends StatelessWidget {
  const WorkerDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate consistent data for "mena" worker
    final workerData = UserDataService.generateUserData(
        'mena', 'mena@example.com', UserRole.worker);

    final String workerImage = "assets/images/placeholder.png";

    return BlocProvider(
      create: (context) => di.sl<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Drawer(
          backgroundColor: lightColorScheme.onPrimary,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerHeader(context, workerData, workerImage),
              _buildDrawerItem(
                context: context,
                icon: Icons.home,
                title: "الصفحة الرئيسية",
                onTap: () {
                  Navigator.pop(context);
                  // Already on home page, no navigation needed
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.assignment,
                title: "طلبات العمل",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkerRequestsPage(),
                    ),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.chat,
                title: "المحادثات",
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to chats page
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.history,
                title: "سجل الحجوزات",
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to history page
                },
              ),
              Divider(color: lightColorScheme.outline),
              _buildDrawerItem(
                context: context,
                icon: Icons.person,
                title: "الملف الشخصي",
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.settings,
                title: "الإعدادات",
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(
    BuildContext context,
    UserModel workerData,
    String imageUrl,
  ) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: lightColorScheme.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: lightColorScheme.onPrimary,
            backgroundImage: AssetImage(imageUrl),
            onBackgroundImageError: (_, __) {
              // Handle error loading image
            },
          ),
          SizedBox(height: 10.h),
          Text(
            workerData.fullName ?? 'العامل',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: lightColorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            workerData.jobTitle ?? 'حرفي',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.onPrimary.withOpacity(0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: lightColorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: lightColorScheme.scrim,
            ),
      ),
      onTap: onTap,
    );
  }
}
