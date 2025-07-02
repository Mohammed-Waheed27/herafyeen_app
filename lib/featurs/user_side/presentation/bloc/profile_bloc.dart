import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/delete_profile_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getCurrentUserUseCase,
    required this.updateProfileUseCase,
    required this.deleteProfileUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<DeleteProfileEvent>(_onDeleteProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<ProfileState> emit) async {
    print('🎯 ProfileBloc: Get current user event received');

    emit(ProfileLoading());
    print('🎯 ProfileBloc: Emitted ProfileLoading state');

    print('🎯 ProfileBloc: Calling get current user use case...');
    final result = await getCurrentUserUseCase();

    print('🎯 ProfileBloc: Received result from use case');
    result.fold(
      (failure) {
        print('❌ ProfileBloc: Get user failed with error: ${failure.message}');
        print('❌ ProfileBloc: Failure type: ${failure.runtimeType}');
        emit(ProfileError(failure.message));
      },
      (user) {
        print('✅ ProfileBloc: Get user successful!');
        print('✅ ProfileBloc: User: ${user.fullName}');
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    print('🎯 ProfileBloc: Update profile event received');
    print('🎯 ProfileBloc: FullName: ${event.fullName}');
    print('🎯 ProfileBloc: Phone: ${event.phone}');

    emit(ProfileLoading());
    print('🎯 ProfileBloc: Emitted ProfileLoading state');

    print('🎯 ProfileBloc: Calling update profile use case...');
    final result = await updateProfileUseCase(
      fullName: event.fullName,
      phone: event.phone,
      location: event.location,
      jobTitle: event.jobTitle,
      workingHours: event.workingHours,
      profileImage: event.profileImage,
    );

    print('🎯 ProfileBloc: Received result from update use case');
    result.fold(
      (failure) {
        print(
            '❌ ProfileBloc: Update profile failed with error: ${failure.message}');
        print('❌ ProfileBloc: Failure type: ${failure.runtimeType}');
        emit(ProfileError(failure.message));
      },
      (user) {
        print('✅ ProfileBloc: Update profile successful!');
        print('✅ ProfileBloc: Updated user: ${user.fullName}');
        emit(ProfileUpdateSuccess(user));
      },
    );
  }

  Future<void> _onDeleteProfile(
      DeleteProfileEvent event, Emitter<ProfileState> emit) async {
    print('🎯 ProfileBloc: Delete profile event received');

    emit(ProfileLoading());
    print('🎯 ProfileBloc: Emitted ProfileLoading state');

    print('🎯 ProfileBloc: Calling delete profile use case...');
    final result = await deleteProfileUseCase();

    print('🎯 ProfileBloc: Received result from delete use case');
    result.fold(
      (failure) {
        print(
            '❌ ProfileBloc: Delete profile failed with error: ${failure.message}');
        print('❌ ProfileBloc: Failure type: ${failure.runtimeType}');
        emit(ProfileError(failure.message));
      },
      (_) {
        print('✅ ProfileBloc: Delete profile successful!');
        emit(ProfileDeleteSuccess());
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    print('🎯 ProfileBloc: Logout event received');

    emit(ProfileLoading());
    print('🎯 ProfileBloc: Emitted ProfileLoading state');

    try {
      print('🎯 ProfileBloc: Calling logout use case...');
      final result = await logoutUseCase();

      print('🎯 ProfileBloc: Received result from logout use case');
      result.fold(
        (failure) {
          print(
              '❌ ProfileBloc: Logout API failed with error: ${failure.message}');
          print('❌ ProfileBloc: Failure type: ${failure.runtimeType}');
          print('❌ ProfileBloc: Failure code: ${failure.code}');

          // Even if API fails, local storage is cleared, so still consider it a success
          // This ensures the user is logged out locally even if the server is unreachable
          print('✅ ProfileBloc: Local logout successful despite API failure');
          print('✅ ProfileBloc: User has been logged out locally');
          emit(LogoutSuccess());
        },
        (_) {
          print('✅ ProfileBloc: Complete logout successful!');
          print('✅ ProfileBloc: User has been logged out and all data cleared');
          emit(LogoutSuccess());
        },
      );
    } catch (e) {
      print('❌ ProfileBloc: Unexpected error during logout: $e');
      emit(ProfileError('حدث خطأ غير متوقع أثناء تسجيل الخروج'));
    }
  }
}
