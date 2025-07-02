import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../user_side/presentation/bloc/profile_bloc.dart';
import '../../../../auth/presentation/pages/login&signup secton/login_signup_page.dart';
import 'sections/profile_header_section.dart';
import 'sections/profile_info_section.dart';
import 'sections/worker_portfolio_section.dart';

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<ProfileBloc>()..add(const GetCurrentUserEvent()),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: lightColorScheme.primary,
          title: Text(
            "الملف الشخصي",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: lightColorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                // Navigate to edit profile page
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: lightColorScheme.error,
                        size: 20.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          color: lightColorScheme.error,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              AppSnackBar.showSuccess(context, "تم تسجيل الخروج بنجاح");
            } else if (state is ProfileError) {
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      const ProfileHeaderSection(),
                      SizedBox(height: 24.h),
                      const ProfileInfoSection(),
                      SizedBox(height: 24.h),
                      const WorkerPortfolioSection(),
                      SizedBox(height: 30.h),
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

  void _showLogoutDialog(BuildContext context) {
    // Capture the ProfileBloc before showing the dialog
    final profileBloc = context.read<ProfileBloc>();

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
                Icons.logout,
                color: lightColorScheme.error,
              ),
              SizedBox(width: 8.w),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: lightColorScheme.scrim,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج من حسابك؟',
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginSignupPage(),
                  ),
                );
                profileBloc.add(const LogoutEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
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
}
