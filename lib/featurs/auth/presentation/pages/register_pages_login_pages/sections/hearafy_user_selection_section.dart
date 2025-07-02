import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';

class HearafyUserSelectionSection extends StatelessWidget {
  final int? activeindex;
  final Function(int?) onindexcahnge;
  const HearafyUserSelectionSection(
      {super.key, required this.activeindex, required this.onindexcahnge});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onindexcahnge(0),
            child: Container(
              height: 50.h,
              width: 150.w,
              decoration: BoxDecoration(
                  color: activeindex == 0
                      ? lightColorScheme.primary
                      : lightColorScheme.secondaryContainer,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r))),
              child: Center(
                  child: Text(
                "حرفي",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: activeindex == 0
                          ? lightColorScheme.onPrimary
                          : lightColorScheme.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () => onindexcahnge(1),
            child: Container(
              height: 50.h,
              width: 150.w,
              decoration: BoxDecoration(
                  color: activeindex == 1
                      ? lightColorScheme.primary
                      : lightColorScheme.secondaryContainer,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r))),
              child: Center(
                  child: Text(
                "مستخدم",
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: activeindex == 1
                          ? lightColorScheme.onPrimary
                          : lightColorScheme.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
