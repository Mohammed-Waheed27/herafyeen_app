import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/auth/presentation/pages/register_pages_login_pages/register_page_1.dart';

import '../../../../../theme/color/app_theme.dart';
import '../register_pages_login_pages/direct_loginpage.dart';
import 'widgets/custom_button.dart';

class LoginSignupPage extends StatelessWidget {
  const LoginSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تسجيل الدخول &انشاء حساب',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: lightColorScheme.primary,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'لديك حساب بالفعل',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: lightColorScheme.scrim),
                  )),
              CustomButton(
                  Title: "تسجيل الدخول",
                  ontap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DirectLoginpage()));
                  }),
              SizedBox(height: 20.h),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "ليس لديك حساب ..قم بانشاء حساب جديد",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: lightColorScheme.scrim),
                  )),
              CustomButton(
                ontap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage1()));
                },
                Title: "انشاء حساب جديد",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
