import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StylizedTitle extends StatelessWidget {
  const StylizedTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 100.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
