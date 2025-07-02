import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/featurs/user_side/presentation/pages/home_page/widgets/user_side_worker_card.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../core/services/user_data_service.dart';
import '../../../../../core/models/user_model.dart';

class UserSideWorkersCategoryPage extends StatefulWidget {
  final String category;
  const UserSideWorkersCategoryPage({super.key, this.category = 'سباك'});

  @override
  State<UserSideWorkersCategoryPage> createState() =>
      _UserSideWorkersCategoryPageState();
}

class _UserSideWorkersCategoryPageState
    extends State<UserSideWorkersCategoryPage> {
  List<Map<String, dynamic>> workersData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    try {
      print('📱 Loading workers for category: ${widget.category}');

      // Simulate API loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate workers data for the specific category
      final workers = UserDataService.generateWorkersForCategory(
          widget.category,
          count: 12);

      setState(() {
        workersData = workers;
        isLoading = false;
      });

      print('📱 Loaded ${workers.length} workers for ${widget.category}');
    } catch (e) {
      print('❌ Error loading workers: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.category,
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: lightColorScheme.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: lightColorScheme.primary),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadWorkers();
            },
          ),
        ],
      ),
      backgroundColor: lightColorScheme.onPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'متاح ${workersData.length} حرفي في ${widget.category}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: lightColorScheme.scrim, fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'اختار الحرفي المناسب لك وتواصل معه مباشرة',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: lightColorScheme.surface, fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
              // Workers grid
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : workersData.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64.r,
                                  color: lightColorScheme.surface,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'لا يوجد حرفيين متاحين حالياً',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: lightColorScheme.surface,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.8,
                              mainAxisExtent: 240.h,
                            ),
                            itemCount: workersData.length,
                            itemBuilder: (context, index) {
                              final worker = workersData[index];
                              return UserSideWorkerCard(
                                jop: worker['phone'],
                                name: worker['name'],
                                exp: worker['experience'].toString(),
                                rating: worker['rating'],
                                workerId: worker['id'],
                                profession: worker['profession'],
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Artisan {
  final String name;
  final int yearsExperience;
  final double rating;
  final String phone;
  final int completedWorks;
  final String bio;

  Artisan({
    required this.name,
    required this.yearsExperience,
    required this.rating,
    required this.phone,
    required this.completedWorks,
    required this.bio,
  });
}
