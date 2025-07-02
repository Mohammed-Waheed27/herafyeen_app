import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/splash_screen_onboarding/onboarding_screens/widgets/onboarding_body_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../theme/color/app_theme.dart';
import '../../../auth/presentation/pages/login&signup secton/login_signup_page.dart';
import '../widgets/onboarding_buttons.dart';

class OnboardingBodySection extends StatelessWidget {
  final PageController cont;
  const OnboardingBodySection({super.key, required this.cont});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/onboarding/1.png',
      'assets/images/onboarding/2.png',
      'assets/images/onboarding/3.png',
    ];

    final List<String> titles = [
      "حلول متعددة لمشاكلك",
      " كل حاجة موثقة وواضحة",
      "حلول مخصصة بتناسب احتياجاتك",
    ];

    final List<String> subTitles = [
      "في تطبيقنا، هتلاقي مجموعة خيارات متنوعة لكل مشاكل بيتك. سواء عندك مشكلة في السباكة أو الكهرباء أو النجارة، كل حاجة متوفرة قدامك بخطوات بسيطة وسريعة. ما تقلقش، كل الحلول عندنا بتكون واضحة وسهلة عشان تحل أي مشكلة في وقتها.",
      "مافيش داعي للخوف من النصب أو الأسعار الغامضة، لأن في التطبيق ده كل وصف وتسعير الخدمة بيكون مكتوب وواضح. كل التفاصيل متوثقة بدقة، عشان تضمن إنك عارف إنت بتدفع على ايه وتاخد الخدمة بالمواصفات اللي انت عايزها.",
      "مش بس بنجمعلك أحسن الحرفيين، لكن كمان بنوفرلك توصيات ذكية مبنية على مشكلتك. يعني التطبيق بيساعدك تختار الخدمة المثالية ويوفرلك نصايح خطوة بخطوة، عشان تلاقي الحل المناسب بسرعة وبدون تعب. كل خطوة محسوبة ومخصصة ليك علشان تحس بتجربة فريدة ومميزة.",
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            height: 600.h,
            child: PageView.builder(
              controller: cont,
              itemBuilder: (context, index) {
                return OnboardingBodyWidget(
                    image: images[index],
                    title: titles[index],
                    subTitle: subTitles[index]);
              },
              itemCount: titles.length,
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: 180.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OnboardingButtons(
                  title: "تخطي",
                  is_scoundary: true,
                  ontap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginSignupPage()));
                  },
                ),
                Container(
                  child: SmoothPageIndicator(
                    controller: cont,
                    onDotClicked: (index) {
                      cont.animateToPage(index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceInOut);
                    },
                    count: 3,
                    effect: JumpingDotEffect(
                      activeDotColor: lightColorScheme.primary,
                      dotHeight: 10.h,
                      dotWidth: 10.w,
                      spacing: 8.w,
                      dotColor: lightColorScheme.secondaryContainer,
                    ),
                  ),
                ),
                OnboardingButtons(
                  title: "التالي",
                  is_scoundary: false,
                  ontap: () {
                    final int currentpage = cont.page?.round() ?? 0;
                    if (currentpage < 2) {
                      cont.animateToPage(currentpage + 1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.bounceInOut);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginSignupPage()));

                      print("this is the last page  ");
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
