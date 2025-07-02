import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/color/app_theme.dart';
import '../../../core/di/injection_container.dart' as di;
import '../../../core/storage/token_storage.dart';
import '../../../core/models/user_model.dart';
import '../../../core/error/failures.dart';
import '../../user_side/domain/usecases/validate_session_usecase.dart';
import '../onboarding_screens/onboarding_main.dart';
import '../../user_side/wrapper/NavigationWrapper.dart';
import '../../worker_side/presentation/worker_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    print('🔍 SplashScreen: Starting session check...');

    try {
      // Wait for a minimum splash duration for better UX
      await Future.delayed(const Duration(seconds: 2));

      final tokenStorage = di.sl<TokenStorage>();

      // Check if we have local session data
      final hasToken = await tokenStorage.hasToken();
      final hasUserData = await tokenStorage.hasUserData();

      print('🔍 SplashScreen: Has token: $hasToken');
      print('🔍 SplashScreen: Has user data: $hasUserData');

      if (hasToken && hasUserData) {
        // Get user data to determine navigation
        final userData = await tokenStorage.getUserData();
        final token = await tokenStorage.getToken();

        if (userData != null && token != null && token.isNotEmpty) {
          print(
              '🔍 SplashScreen: Local session found for user: ${userData.fullName}');
          print('🔍 SplashScreen: User role: ${userData.role}');

          // Navigate directly to home with local session
          print('🔍 SplashScreen: Proceeding with local session');
          _navigateToHome(userData);
        } else {
          print(
              '🔍 SplashScreen: Invalid local session data, clearing and going to onboarding');
          await tokenStorage.clearAll();
          _navigateToOnboarding();
        }
      } else {
        print('🔍 SplashScreen: No local session found, going to onboarding');
        _navigateToOnboarding();
      }
    } catch (e) {
      print('❌ SplashScreen: Error during session check: $e');
      // On error, clear any corrupted data and go to onboarding
      try {
        final tokenStorage = di.sl<TokenStorage>();
        await tokenStorage.clearAll();
      } catch (clearError) {
        print('❌ SplashScreen: Error clearing storage: $clearError');
      }
      _navigateToOnboarding();
    }
  }

  Future<void> _validateWithServer(UserModel userData) async {
    print('🔍 SplashScreen: Validating session with server...');

    try {
      final validateSessionUseCase = di.sl<ValidateSessionUseCase>();
      final result = await validateSessionUseCase();

      result.fold(
        (failure) {
          print(
              '🔍 SplashScreen: Server validation failed: ${failure.message}');

          // If it's an auth failure, clear session and go to onboarding
          if (failure is AuthFailure) {
            print(
                '🔍 SplashScreen: Authentication failed - redirecting to login');
            _navigateToOnboarding();
          } else {
            // For network or server failures, continue with local session
            print(
                '🔍 SplashScreen: Network/server error - proceeding with local session');
            _navigateToHome(userData);
          }
        },
        (isValid) {
          if (isValid) {
            print(
                '🔍 SplashScreen: Server validation successful - proceeding to home');
            _navigateToHome(userData);
          } else {
            print(
                '🔍 SplashScreen: Server validation failed - session invalid');
            _navigateToOnboarding();
          }
        },
      );
    } catch (e) {
      print('❌ SplashScreen: Exception during server validation: $e');
      // On exception, proceed with local session
      print(
          '🔍 SplashScreen: Proceeding with local session due to validation error');
      _navigateToHome(userData);
    }
  }

  void _navigateToHome(UserModel user) {
    print('🔍 SplashScreen: Navigating to home for ${user.role.name} user');

    if (user.role == UserRole.worker) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WorkerMainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationWrapper()),
      );
    }
  }

  void _navigateToOnboarding() {
    print('🔍 SplashScreen: Navigating to onboarding');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.onPrimary,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/splashback.png"),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 370.w,
                height: 370.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"))),
              ),
              SizedBox(height: 32.h),
              // Loading indicator for session check
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  color: lightColorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'جاري التحقق من جلسة المستخدم...',
                style: TextStyle(
                  color: lightColorScheme.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
