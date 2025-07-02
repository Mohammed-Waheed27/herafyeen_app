import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/color/app_theme.dart';

class OnboardingBodyWidget extends StatelessWidget {
  const OnboardingBodyWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});

  final String image;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: lightColorScheme.primary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 200,
            decoration:
                BoxDecoration(image: DecorationImage(image: AssetImage(image))),
          ),
        ),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            textAlign: TextAlign.center,
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: lightColorScheme.scrim,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
