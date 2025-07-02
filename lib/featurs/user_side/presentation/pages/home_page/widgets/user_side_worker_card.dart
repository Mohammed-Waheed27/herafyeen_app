import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../theme/color/app_theme.dart';
import '../user_side_worker_profile_page.dart';

class UserSideWorkerCard extends StatelessWidget {
  final String name;
  final String exp;
  final String rating;
  final String jop;
  final String? workerId;
  final String? profession;

  const UserSideWorkerCard({
    super.key,
    required this.name,
    required this.exp,
    required this.rating,
    required this.jop,
    this.workerId,
    this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: lightColorScheme.onSecondary,
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      height: 200.h,
      width: 150.w,
      child: Column(
        children: [
          Container(
            width: 150.w,
            height: 90.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                    image: AssetImage("assets/images/w2.jpg"),
                    fit: BoxFit.contain)),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: lightColorScheme.primary, fontSize: 18.sp),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      jop,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.primaryContainer,
                          fontSize: 14.sp),
                    ),
                    Text(
                      "موبايل",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.scrim, fontSize: 14.sp),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      exp,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.primaryContainer,
                          fontSize: 14.sp),
                    ),
                    Text(
                      ":الخبره",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.scrim, fontSize: 14.sp),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      rating,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.primaryContainer,
                          fontSize: 14.sp),
                    ),
                    Text(
                      ":التقييم",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: lightColorScheme.scrim, fontSize: 14.sp),
                    ),
                  ],
                )
              ],
            ),
          )),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => UserSideWorkerProfilePage(
                        workerId: workerId ?? 'unknown',
                        workerName: name,
                        profession: profession ?? jop,
                        rating: rating,
                        experience: exp,
                      )));
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                  color: lightColorScheme.primary,
                  borderRadius: BorderRadius.circular(4)),
              child: Center(
                child: Text(
                  "عرض الملف الشخصي",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: lightColorScheme.onPrimary, fontSize: 12.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
