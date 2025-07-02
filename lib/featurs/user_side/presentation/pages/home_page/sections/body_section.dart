import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/user_side/presentation/pages/home_page/user_side_workers_category_page.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class BodySection extends StatelessWidget {
  final String title;
  final List<String> content;

  const BodySection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.grey),
          ),
          SizedBox(
            height: 16.h,
          ),
          SizedBox(
            height: 120.h,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: content.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 6, // space between rows
                    crossAxisSpacing: 6, // space between columns
                    childAspectRatio: 1, // adjust to your tile’s shape
                    // mainAxisExtent: 85.h,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the category page with the selected profession
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => UserSideWorkersCategoryPage(
                                  category: content[index],
                                )));
                      },
                      child: Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1.5, color: lightColorScheme.primary),
                            color: lightColorScheme.onSecondary),
                        child: Center(
                          child: Text(
                            content[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: lightColorScheme.scrim,
                                    fontSize: 16.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
