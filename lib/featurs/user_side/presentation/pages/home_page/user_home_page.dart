import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../theme/color/app_theme.dart';
import 'sections/body_section.dart';

//this is the type for the page content texts
class section {
  final String category;
  final List<String> content;

  section({required this.category, required this.content});
}

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<section> body_content = [
      section(
        category: "الصيانة المنزلية",
        content: [
          'سباك',
          'كهربائي',
          'فني صيانة أجهزة كهربائية',
          'فني تكييف وتبريد',
        ],
      ),
      section(
        category: "لتشطيبات والديكور",
        content: [
          'نقاش (دهانات وتشطيبات)',
          'فني جبس بورد',
          'فني ديكور وإضاءة',
          'مبيض محارة',
        ],
      ),
      section(
        category: "أعمال البناء والترميم",
        content: [
          'عامل محارة',
          'مقاول ترميمات صغيرة',
          'فني نجارة مسلح',
        ],
      ),
      section(
        category: "الأبواب والنوافذ",
        content: [
          'نجار',
          'فني ألوميتال (شبابيك وأبواب)',
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        iconTheme: IconThemeData(
            color: lightColorScheme
                .secondary), // This changes the back arrow color
        title: Text(
          'الصفحة الرئيسية',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: lightColorScheme.scrim,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
        ),
        // the button for the profile
        actions: [
          CircleAvatar(
            backgroundColor: lightColorScheme.primary,
            child: Icon(
              Icons.person,
              color: lightColorScheme.onPrimary,
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                // tha main text title for the featuer
                Text(
                  "اختار الخدمة اللي محتاجها وهتلاقي أفضل الحرفيين بضغطة زر",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                  textAlign: TextAlign.center,
                ),
                // the text question for the user
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "إنتَ عايز فني إيه؟",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: lightColorScheme.scrim,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
                // the section for the home service
                Container(
                  height: 680.h,
                  child: ListView.builder(
                      itemCount: body_content.length,
                      itemBuilder: (context, index) {
                        return BodySection(
                          title: body_content[index].category,
                          content: body_content[index].content,
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
