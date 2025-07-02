import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

import 'user_side_application_page.dart';

class UserSideWorkerProfilePage extends StatelessWidget {
  final String workerId;
  final String workerName;
  final String profession;
  final String rating;
  final String experience;

  const UserSideWorkerProfilePage({
    super.key,
    required this.workerId,
    required this.workerName,
    required this.profession,
    required this.rating,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: lightColorScheme.onPrimary,
          title: Text(
            "الملف الشخصي للحرفي",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: lightColorScheme.primary, fontSize: 20.sp),
          ),
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(height: 16.h),
                      // image section is here
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            color: lightColorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: AssetImage("assets/images/w2.jpg"))),
                      ),
                      // the name
                      Text(
                        workerName,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: lightColorScheme.primary),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      // the work feild or the herfa hahahah
                      Text(
                        profession,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: lightColorScheme.surface),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      // the rating section is here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rate_rounded,
                            color: lightColorScheme.primary,
                          ),
                          Icon(
                            Icons.star_rate_rounded,
                            color: lightColorScheme.primary,
                          ),
                          Icon(
                            Icons.star_rate_rounded,
                            color: lightColorScheme.primary,
                          ),
                          Icon(
                            Icons.star_rate_rounded,
                            color: lightColorScheme.primary,
                          ),
                          Icon(
                            Icons.star_border_rounded,
                            color: lightColorScheme.primary,
                          ),
                        ],
                      ),
                      // the phone number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "01270640035",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: lightColorScheme.surface),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "رقم الهاتف",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: lightColorScheme.surface),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      // total jops done

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "27",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: lightColorScheme.surface),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            "عدد الاعمال المنفذه",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: lightColorScheme.surface),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // the discription for the heafy
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "نبذه عن الحرفي",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: lightColorScheme.scrim,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      // the info about the herafy
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 250,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: lightColorScheme.secondaryContainer),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          textAlign: TextAlign.right,
                          """التسجيل مع حرفي
اسم الحرفي (الصنايعي)
نوع الحرفة(الصنعه)   
نوع الحرفة(الصنع     
نوع الحرفة(الصنع  
نوع الحرفة(الصنع
نوع الحرفة(الصنعه)
التقييم
0
متوسط السعر
نبذه عن الحرفي (الصنايعي)
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
تواصل معـــــــــي""",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: lightColorScheme.scrim),
                        ),
                      ),
                      SizedBox(
                        height: 150.h,
                      )
                    ],
                  ),
                ),
              ),
              //the contact button
              Positioned(
                right: 10,
                left: 10,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => UserSideApplicationPage(
                              workerId: workerId,
                              workerName: workerName,
                              profession: profession,
                            )));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: lightColorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "حجز",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: lightColorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
