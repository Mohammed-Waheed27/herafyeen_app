import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/models/user_model.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    print('🎯 AuthBloc: Registration event received');
    print('🎯 AuthBloc: Username: ${event.request.username}');
    print('🎯 AuthBloc: Email: ${event.request.email}');
    print('🎯 AuthBloc: Role: ${event.request.role}');

    emit(AuthLoading());
    print('🎯 AuthBloc: Emitted AuthLoading state');

    print('🎯 AuthBloc: Calling register use case...');
    final result = await registerUseCase(event.request);

    print('🎯 AuthBloc: Received result from use case');
    result.fold(
      (failure) {
        print('❌ AuthBloc: Registration failed with error: ${failure.message}');
        print('❌ AuthBloc: Failure type: ${failure.runtimeType}');
        emit(AuthError(failure.message));
      },
      (authResponse) {
        print('✅ AuthBloc: Registration successful!');
        print('✅ AuthBloc: User ID: ${authResponse.user.id}');
        print('✅ AuthBloc: User role: ${authResponse.user.role}');
        print('✅ AuthBloc: Token received: ${authResponse.token.isNotEmpty}');
        emit(AuthSuccess(authResponse.user, authResponse.token));
      },
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    print('🎯 AuthBloc: Login event received');
    print('🎯 AuthBloc: Username: ${event.username}');
    print('🎯 AuthBloc: Password length: ${event.password.length}');

    emit(AuthLoading());
    print('🎯 AuthBloc: Emitted AuthLoading state');

    print('🎯 AuthBloc: Calling login use case...');
    final result = await loginUseCase(event.username, event.password);

    print('🎯 AuthBloc: Received result from login use case');
    result.fold(
      (failure) {
        print('❌ AuthBloc: Login failed with error: ${failure.message}');
        print('❌ AuthBloc: Failure type: ${failure.runtimeType}');
        emit(AuthError(failure.message));
      },
      (authResponse) {
        print('✅ AuthBloc: Login successful!');
        print('✅ AuthBloc: User ID: ${authResponse.user.id}');
        print('✅ AuthBloc: User role: ${authResponse.user.role}');
        print('✅ AuthBloc: Token received: ${authResponse.token.isNotEmpty}');
        emit(AuthSuccess(authResponse.user, authResponse.token));
      },
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthInitial());
  }
}
