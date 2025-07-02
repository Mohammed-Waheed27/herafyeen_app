import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/theme/color/app_theme.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../bloc/worker_requests_bloc.dart';
import '../../bloc/worker_requests_event.dart';
import 'sections/latest_reservations_section.dart';
import 'sections/worker_welcome_section.dart';
import 'widgets/drawer_widget.dart';
import '../requests_page/worker_requests_page.dart';

class WorkerHomePage extends StatelessWidget {
  const WorkerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<WorkerRequestsBloc>()..add(const GetMyWorkRequestsEvent()),
      child: Scaffold(
        backgroundColor: lightColorScheme.onPrimary,
        appBar: AppBar(
          backgroundColor: lightColorScheme.primary,
          title: Text(
            "الصفحة الرئيسية",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: lightColorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: lightColorScheme.onPrimary),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.assignment),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkerRequestsPage(),
                  ),
                );
              },
            ),
          ],
        ),
        drawer: const WorkerDrawerWidget(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WorkerWelcomeSection(),
                  SizedBox(height: 20.h),
                  const LatestReservationsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
