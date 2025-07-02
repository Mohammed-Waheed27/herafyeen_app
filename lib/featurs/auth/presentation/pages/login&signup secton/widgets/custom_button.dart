import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String Title;
  final Function()? ontap;

  const CustomButton({super.key, required this.Title, this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        height: 50.h,
        decoration: BoxDecoration(
          color: lightColorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            Title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: lightColorScheme.onPrimary,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}
