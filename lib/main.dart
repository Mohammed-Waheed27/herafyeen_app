import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mw_herafy/featurs/splash_screen_onboarding/splash_screen/splash_screen.dart';
import 'theme/color/app_theme.dart';
import 'theme/font/fontthem.dart';
import 'core/di/injection_container.dart' as di;
import 'featurs/auth/presentation/bloc/auth_bloc.dart';
import 'featurs/user_side/presentation/bloc/profile_bloc.dart';
import 'featurs/worker_side/presentation/bloc/worker_requests_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    // this is where i put my shit

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => di.sl<AuthBloc>(),
            ),
            BlocProvider<ProfileBloc>(
              create: (context) => di.sl<ProfileBloc>(),
            ),
            BlocProvider<WorkerRequestsBloc>(
              create: (context) => di.sl<WorkerRequestsBloc>(),
            ),
          ],
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'حرفي',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            textTheme: FontTheme.textTheme,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
