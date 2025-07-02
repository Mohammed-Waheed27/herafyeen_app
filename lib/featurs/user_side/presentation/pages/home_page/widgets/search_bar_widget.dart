import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../theme/color/app_theme.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: lightColorScheme.onPrimary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Form(
        child: TextFormField(
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: lightColorScheme.onSecondary,
                fontSize: 16.sp,
              ),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'ابحث عن العملاء',
            hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.onSecondary,
                ),
            filled: true,
            fillColor: lightColorScheme.onSecondary.withAlpha(50),
            suffixIcon: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.search,
                color: lightColorScheme.onSecondary.withAlpha(255),
                size: 30.h,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        ),
      ),
    );
  }
}
