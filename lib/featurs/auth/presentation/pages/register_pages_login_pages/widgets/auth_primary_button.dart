import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String button_label;
  final bool main;
  final Function()? onTap;

  const AuthPrimaryButton(
      {super.key, required this.button_label, this.main = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.symmetric(vertical: 10),
        width: 330.w,
        height: 52.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: lightColorScheme.primary),
        child: Center(
            child: Text(
          button_label,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: main ? 24.sp : 16.sp,
                color: lightColorScheme.onPrimary,
              ),
        )),
      ),
    );
  }
}
