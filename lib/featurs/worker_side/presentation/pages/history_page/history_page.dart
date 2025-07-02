import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import 'sections/reservation_history_section.dart';

class WorkerHistoryPage extends StatefulWidget {
  const WorkerHistoryPage({Key? key}) : super(key: key);

  @override
  State<WorkerHistoryPage> createState() => _WorkerHistoryPageState();
}

class _WorkerHistoryPageState extends State<WorkerHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          "سجل الحجوزات",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: lightColorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
          unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
          tabs: const [
            Tab(text: "مكتملة"),
            Tab(text: "ملغية"),
            Tab(text: "الكل"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Completed reservations tab
          ReservationHistorySection(statusFilter: 'completed'),

          // Cancelled reservations tab
          ReservationHistorySection(statusFilter: 'cancelled'),

          // All reservations tab
          ReservationHistorySection(statusFilter: 'all'),
        ],
      ),
    );
  }
}
