import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/header.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/sections/logo_register_section.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/auth_primary_button.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/widgets/register_textefilds.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/utils/app_snack_bar.dart';
import '../../../../../core/models/user_model.dart';
import '../../../../user_side/presentation/pages/home_page/user_home_page.dart';
import '../../../../user_side/wrapper/NavigationWrapper.dart';
import '../../../../worker_side/presentation/worker_main_screen.dart';
import '../../bloc/auth_bloc.dart';
import 'register_page_1.dart';

class DirectLoginpage extends StatefulWidget {
  const DirectLoginpage({super.key});

  @override
  State<DirectLoginpage> createState() => _DirectLoginpageState();
}

class _DirectLoginpageState extends State<DirectLoginpage> {
  final email_ctrl = TextEditingController();
  final password_ctrl = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    email_ctrl.dispose();
    password_ctrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: SingleChildScrollView(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    AppSnackBar.showLoading(context, "جاري تسجيل الدخول...");
                  } else if (state is AuthSuccess) {
                    AppSnackBar.showSuccess(context, "تم تسجيل الدخول بنجاح");

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
                    children: [
                      StylizedTitle(),
                      HeaderText(Title: "تسجيل الدخول"),
                      Container(
                        height: 500,
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RegisterTextefilds(
                                label: "اسم المستخدم أو البريد الالكتروني",
                                hint: "username or email",
                                controller: email_ctrl,
                                valodator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'اسم المستخدم أو البريد الالكتروني مطلوب';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.h),
                              RegisterTextefilds(
                                label: "كلمة المرور",
                                hint: "password",
                                obscure: true,
                                controller: password_ctrl,
                                valodator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'كلمة المرور مطلوبة';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      AuthPrimaryButton(
                        button_label: state is AuthLoading
                            ? "جاري تسجيل الدخول..."
                            : "تسجيل الدخول",
                        onTap: state is AuthLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                if (formkey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        LoginEvent(
                                          username: email_ctrl.text.trim(),
                                          password: password_ctrl.text,
                                        ),
                                      );
                                }
                              },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPage1()));
                            },
                            child: Text(
                              "انشاء حساب جديد",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                      color: lightColorScheme.primary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            "ليس لديك حساب ؟",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    color: lightColorScheme.surface,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
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
}
