import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../theme/color/app_theme.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/models/user_model.dart';
import '../../../../../core/storage/token_storage.dart';
import '../../../../auth/presentation/pages/login&signup secton/login_signup_page.dart';

import '../../bloc/profile_bloc.dart';
import '../profile_page/profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<ProfileBloc>()..add(const GetCurrentUserEvent()),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          backgroundColor: lightColorScheme.onPrimary,
          elevation: 0,
          title: Text(
            'الإعدادات',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
          ),
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileDeleteSuccess) {
              AppSnackBar.showSuccess(context, "تم حذف الحساب بنجاح");
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const LoginSignupPage()),
                (route) => false,
              );
            } else if (state is ProfileError) {
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      // Profile section
                      if (state is ProfileLoaded)
                        _buildProfileSection(context, state.user)
                      else if (state is ProfileLoading)
                        _buildLoadingProfileSection(context)
                      else if (state is ProfileError)
                        _buildErrorProfileSection(context)
                      else
                        _buildLoadingProfileSection(context),
                      SizedBox(height: 24.h),

                      // Account settings
                      _buildSectionTitle(context, 'إعدادات الحساب'),
                      _buildSettingItem(
                        context,
                        icon: Icons.person,
                        title: 'المعلومات الشخصية',
                        subtitle: 'تعديل معلوماتك الشخصية',
                        iconColor: lightColorScheme.primary,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                      _buildSettingItem(
                        context,
                        icon: Icons.lock,
                        title: 'الأمان والخصوصية',
                        subtitle: 'كلمة المرور وتأمين الحساب',
                        iconColor: lightColorScheme.secondary,
                        onTap: () {
                          // Navigate to security settings
                        },
                      ),

                      SizedBox(height: 24.h),
                      // Note: Logout functionality is now available in the Profile page
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserModel user) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: lightColorScheme.onSecondary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: lightColorScheme.primary,
            backgroundImage: user.profileImageUrl != null
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null
                ? Text(
                    user.fullName.isNotEmpty
                        ? user.fullName[0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      color: lightColorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: lightColorScheme.scrim,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: lightColorScheme.surface,
                  ),
                ),
                if (user.phone != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    user.phone!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: lightColorScheme.surface,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: lightColorScheme.primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingProfileSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: lightColorScheme.onSecondary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: lightColorScheme.primary.withOpacity(0.3),
            child: CircularProgressIndicator(
              color: lightColorScheme.primary,
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: lightColorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 16.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: lightColorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorProfileSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: lightColorScheme.onSecondary,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: lightColorScheme.error.withOpacity(0.1),
            child: Icon(
              Icons.error,
              color: lightColorScheme.error,
              size: 24.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'خطأ في تحميل البيانات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: lightColorScheme.scrim,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'انقر للمحاولة مرة أخرى',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: lightColorScheme.surface,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: lightColorScheme.primary,
            ),
            onPressed: () {
              context.read<ProfileBloc>().add(const GetCurrentUserEvent());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: lightColorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    VoidCallback? onTap,
    bool hasSwitch = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: lightColorScheme.scrim,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: lightColorScheme.surface,
                    ),
                  ),
                ],
              ),
            ),
            hasSwitch
                ? Switch(
                    value: false, // Default value
                    onChanged: (value) {
                      // Toggle setting
                    },
                    activeColor: lightColorScheme.primary,
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 16.r,
                    color: lightColorScheme.surface,
                  ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تسجيل الخروج',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightColorScheme.scrim,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: lightColorScheme.surface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(color: lightColorScheme.surface),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: Text(
                'تسجيل الخروج',
                style: TextStyle(color: lightColorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    // Clear local storage and navigate to login
    final tokenStorage = di.sl<TokenStorage>();
    await tokenStorage.clearAll();

    AppSnackBar.showSuccess(context, "تم تسجيل الخروج بنجاح");

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginSignupPage()),
      (route) => false,
    );
  }
}
