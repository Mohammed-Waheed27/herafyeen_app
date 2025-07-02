import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../network/api_client.dart';
import '../storage/token_storage.dart';
import '../../featurs/auth/data/datasources/auth_remote_datasource.dart';
import '../../featurs/auth/data/repositories/auth_repository_impl.dart';
import '../../featurs/auth/domain/repositories/auth_repository.dart';
import '../../featurs/auth/domain/usecases/register_usecase.dart';
import '../../featurs/auth/domain/usecases/login_usecase.dart';
import '../../featurs/auth/domain/usecases/logout_usecase.dart';
import '../../featurs/auth/presentation/bloc/auth_bloc.dart';

// Profile imports
import '../../featurs/user_side/data/datasources/profile_remote_datasource.dart';
import '../../featurs/user_side/data/repositories/profile_repository_impl.dart';
import '../../featurs/user_side/domain/repositories/profile_repository.dart';
import '../../featurs/user_side/domain/usecases/get_current_user_usecase.dart';
import '../../featurs/user_side/domain/usecases/update_profile_usecase.dart';
import '../../featurs/user_side/domain/usecases/delete_profile_usecase.dart';
import '../../featurs/user_side/domain/usecases/validate_session_usecase.dart';
import '../../featurs/user_side/presentation/bloc/profile_bloc.dart';

// Workers imports
import '../../featurs/user_side/data/datasources/workers_remote_datasource.dart';
import '../../featurs/user_side/data/repositories/workers_repository_impl.dart';
import '../../featurs/user_side/domain/repositories/workers_repository.dart';
import '../../featurs/user_side/domain/usecases/get_workers_usecase.dart';

// Worker Requests imports
import '../../featurs/worker_side/data/datasources/worker_requests_remote_datasource.dart';
import '../../featurs/worker_side/data/repositories/worker_requests_repository_impl.dart';
import '../../featurs/worker_side/domain/repositories/worker_requests_repository.dart';
import '../../featurs/worker_side/domain/usecases/get_my_work_requests_usecase.dart';
import '../../featurs/worker_side/domain/usecases/accept_request_usecase.dart';
import '../../featurs/worker_side/domain/usecases/reject_request_usecase.dart';
import '../../featurs/worker_side/domain/usecases/complete_request_usecase.dart';
import '../../featurs/worker_side/domain/usecases/get_request_history_usecase.dart';
import '../../featurs/worker_side/presentation/bloc/worker_requests_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => TokenStorage());
  sl.registerLazySingleton(() => ApiClient(client: sl(), tokenStorage: sl()));

  // Auth Feature
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      tokenStorage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // BLoC
  sl.registerFactory(() => AuthBloc(
        registerUseCase: sl(),
        loginUseCase: sl(),
      ));

  // Profile Feature
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      tokenStorage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProfileUseCase(sl()));
  sl.registerLazySingleton(() => ValidateSessionUseCase(sl()));

  // BLoC
  sl.registerFactory(() => ProfileBloc(
        getCurrentUserUseCase: sl(),
        updateProfileUseCase: sl(),
        deleteProfileUseCase: sl(),
        logoutUseCase: sl(),
      ));

  // Workers Feature
  // Data sources
  sl.registerLazySingleton<WorkersRemoteDataSource>(
    () => WorkersRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<WorkersRepository>(
    () => WorkersRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWorkersUseCase(sl()));

  // Worker Requests Feature
  // Data sources
  sl.registerLazySingleton<WorkerRequestsRemoteDataSource>(
    () => WorkerRequestsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<WorkerRequestsRepository>(
    () => WorkerRequestsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMyWorkRequestsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));
  sl.registerLazySingleton(() => CompleteRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetRequestHistoryUseCase(sl()));

  // BLoC
  sl.registerFactory(() => WorkerRequestsBloc(
        getMyWorkRequestsUseCase: sl(),
        acceptRequestUseCase: sl(),
        rejectRequestUseCase: sl(),
        completeRequestUseCase: sl(),
        getRequestHistoryUseCase: sl(),
      ));
}
