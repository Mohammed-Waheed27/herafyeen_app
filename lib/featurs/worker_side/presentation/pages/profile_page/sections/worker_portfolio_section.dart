import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';

class WorkerPortfolioSection extends StatelessWidget {
  const WorkerPortfolioSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock portfolio data - in a real app this would come from a repository
    final List<String> portfolioImages = [
      "assets/images/placeholder.png",
      "assets/images/placeholder.png",
      "assets/images/placeholder.png",
      "assets/images/placeholder.png",
      "assets/images/placeholder.png",
      "assets/images/placeholder.png",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "معرض أعمالي",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                // Handle add new portfolio item
              },
              icon: Icon(
                Icons.add,
                color: lightColorScheme.primary,
                size: 20.w,
              ),
              label: Text(
                "إضافة",
                style: TextStyle(
                  color: lightColorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildPortfolioGrid(context, portfolioImages),
      ],
    );
  }

  Widget _buildPortfolioGrid(BuildContext context, List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return _buildPortfolioItem(context, images[index], index);
      },
    );
  }

  Widget _buildPortfolioItem(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        // Show full-screen image preview
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: lightColorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.image_not_supported,
                      color: lightColorScheme.primary,
                      size: 32.w,
                    ),
                  );
                },
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () {
                    // Handle delete portfolio item
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: lightColorScheme.error,
                      size: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
