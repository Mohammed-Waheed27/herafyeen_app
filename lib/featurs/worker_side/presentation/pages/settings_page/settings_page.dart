import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../user_side/presentation/bloc/profile_bloc.dart';
import '../../../../auth/presentation/pages/login&signup secton/login_signup_page.dart';
import 'widgets/settings_tile.dart';

class WorkerSettingsPage extends StatefulWidget {
  const WorkerSettingsPage({Key? key}) : super(key: key);

  @override
  State<WorkerSettingsPage> createState() => _WorkerSettingsPageState();
}

class _WorkerSettingsPageState extends State<WorkerSettingsPage> {
  // Settings states
  bool _notificationsEnabled = true;
  bool _locationVisible = true;
  bool _availableForWork = true;
  String _selectedLanguage = 'العربية';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            AppSnackBar.showSuccess(context, "تم تسجيل الخروج بنجاح");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginSignupPage(),
              ),
              (route) => false,
            );
          } else if (state is ProfileError) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: lightColorScheme.onPrimary,
          appBar: AppBar(
            backgroundColor: lightColorScheme.primary,
            title: Text(
              "الإعدادات",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: lightColorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, "الإعدادات العامة"),
                    SizedBox(height: 16.h),
                    SettingsTile(
                      title: "الإشعارات",
                      subtitle: "تفعيل/إلغاء الإشعارات",
                      icon: Icons.notifications,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: lightColorScheme.primary,
                      ),
                    ),
                    SettingsTile(
                      title: "متاح للعمل",
                      subtitle: "اظهار حالتك للمستخدمين",
                      icon: Icons.work,
                      trailing: Switch(
                        value: _availableForWork,
                        onChanged: (value) {
                          setState(() {
                            _availableForWork = value;
                          });
                        },
                        activeColor: lightColorScheme.primary,
                      ),
                    ),
                    SettingsTile(
                      title: "إظهار موقعي",
                      subtitle: "السماح للمستخدمين برؤية موقعك",
                      icon: Icons.location_on,
                      trailing: Switch(
                        value: _locationVisible,
                        onChanged: (value) {
                          setState(() {
                            _locationVisible = value;
                          });
                        },
                        activeColor: lightColorScheme.primary,
                      ),
                    ),
                    SettingsTile(
                      title: "اللغة",
                      subtitle: _selectedLanguage,
                      icon: Icons.language,
                      onTap: () {
                        _showLanguageSelectionDialog();
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionTitle(context, "الحساب"),
                    SizedBox(height: 16.h),
                    SettingsTile(
                      title: "تغيير كلمة المرور",
                      subtitle: "تعديل كلمة المرور الخاصة بك",
                      icon: Icons.lock,
                      onTap: () {
                        // Navigate to change password screen
                      },
                    ),
                    SettingsTile(
                      title: "الخصوصية والأمان",
                      subtitle: "إدارة إعدادات الخصوصية",
                      icon: Icons.security,
                      onTap: () {
                        // Navigate to privacy settings
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildSectionTitle(context, "الدعم"),
                    SizedBox(height: 16.h),
                    SettingsTile(
                      title: "مركز المساعدة",
                      subtitle: "الأسئلة الشائعة والدعم",
                      icon: Icons.help,
                      onTap: () {
                        // Navigate to help center
                      },
                    ),
                    SettingsTile(
                      title: "تواصل معنا",
                      subtitle: "اتصل بفريق الدعم",
                      icon: Icons.support_agent,
                      onTap: () {
                        // Navigate to contact support
                      },
                    ),
                    SettingsTile(
                      title: "عن التطبيق",
                      subtitle: "معلومات عن التطبيق",
                      icon: Icons.info,
                      onTap: () {
                        // Show about dialog
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: ElevatedButton(
        onPressed: () {
          _showLogoutConfirmationDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.error.withOpacity(0.1),
          foregroundColor: lightColorScheme.error,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          "تسجيل الخروج",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    // Capture the ProfileBloc before showing the dialog
    final profileBloc = context.read<ProfileBloc>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: lightColorScheme.onPrimary,
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
            'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
            style: TextStyle(
              color: lightColorScheme.surface,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: lightColorScheme.surface,
                  fontSize: 14.sp,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Use the captured ProfileBloc reference
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

  Future<void> _showLanguageSelectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('اختر اللغة'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _selectedLanguage = 'العربية';
                });
                Navigator.pop(context);
              },
              child: const Text('العربية'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
                Navigator.pop(context);
              },
              child: const Text('English'),
            ),
          ],
        );
      },
    );
  }
}
