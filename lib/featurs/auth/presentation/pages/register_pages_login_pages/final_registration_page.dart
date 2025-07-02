import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/header.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/logo_register_section.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/auth_primary_button.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/models/user_model.dart';
import '../../../domain/entities/register_request.dart';
import '../../bloc/auth_bloc.dart';
import '../../models/registration_data.dart';
import '../../../../user_side/wrapper/NavigationWrapper.dart';
import '../../../../worker_side/presentation/worker_main_screen.dart';

class FinalRegistrationPage extends StatelessWidget {
  final RegistrationData registrationData;

  const FinalRegistrationPage({
    super.key,
    required this.registrationData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Center(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    AppSnackBar.showLoading(context, "جاري إنشاء الحساب...");
                  } else if (state is AuthSuccess) {
                    AppSnackBar.showSuccess(context, "تم إنشاء الحساب بنجاح!");

                    // Navigate based on user role
                    if (state.user.role == UserRole.worker) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => WorkerMainScreen()),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => NavigationWrapper()),
                      );
                    }
                  } else if (state is AuthError) {
                    AppSnackBar.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacer(),
                      HeaderText(
                        Title: state is AuthSuccess
                            ? "تهانيا تم انشاء حسابك بنجاح"
                            : "الخطوة الأخيرة",
                      ),
                      if (state is! AuthSuccess) ...[
                        SizedBox(height: 20.h),
                        Text(
                          "اضغط لإكمال إنشاء حسابك",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: lightColorScheme.scrim,
                                    fontSize: 16.sp,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: 50.h),
                      StylizedTitle(),
                      Spacer(),
                      AuthPrimaryButton(
                        button_label: state is AuthLoading
                            ? "جاري إنشاء الحساب..."
                            : state is AuthSuccess
                                ? "تسجيل الدخول"
                                : "إنشاء الحساب",
                        onTap: state is AuthLoading
                            ? null
                            : state is AuthSuccess
                                ? () {
                                    // Navigate based on user role after success
                                    if (state.user.role == UserRole.worker) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WorkerMainScreen()),
                                      );
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NavigationWrapper()),
                                      );
                                    }
                                  }
                                : () {
                                    _submitRegistration(context);
                                  },
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitRegistration(BuildContext context) {
    final registerRequest = RegisterRequest(
      username: registrationData.generateUsername(),
      fullName: registrationData.fullName,
      email: registrationData.email,
      password: registrationData.password,
      role: registrationData.role,
      location: registrationData.location,
      jobTitle: registrationData.jobTitle ?? '',
      workingHours: registrationData.workingHours ?? '8:00 AM - 6:00 PM',
      phone: registrationData.phone,
      profileImage: registrationData.profileImage,
      idCardImage: registrationData.idCardImage,
    );

    context.read<AuthBloc>().add(RegisterEvent(registerRequest));
  }
}
