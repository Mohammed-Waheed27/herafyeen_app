import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/services/user_data_service.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, AuthResponse>> register(
      RegisterRequest request) async {
    print(
        '🏪 AuthRepository: Starting registration for username: ${request.username}');
    print('🏪 AuthRepository: User role: ${request.role}');
    print('🏪 AuthRepository: Email: ${request.email}');

    try {
      print(
          '🏪 AuthRepository: Calling remote data source for registration...');
      final result = await remoteDataSource.register(request);

      print('🏪 AuthRepository: Registration successful!');
      print('🏪 AuthRepository: Received token: ${result.token}');
      print('🏪 AuthRepository: User ID: ${result.user.id}');

      // Generate enhanced user data if some fields are missing
      UserModel enhancedUser = result.user;
      if (result.user.fullName.isEmpty ||
          result.user.location == null ||
          result.user.phone == null) {
        print(
            '🏪 AuthRepository: Enhancing user data with generated information');
        final generatedUser = UserDataService.generateUserData(
            result.user.username, result.user.email, result.user.role);

        // Merge API data with generated data, preferring API data when available
        enhancedUser = result.user.copyWith(
          fullName: result.user.fullName.isNotEmpty
              ? result.user.fullName
              : generatedUser.fullName,
          location: result.user.location ?? generatedUser.location,
          phone: result.user.phone ?? generatedUser.phone,
          jobTitle: result.user.jobTitle ?? generatedUser.jobTitle,
          workingHours: result.user.workingHours ?? generatedUser.workingHours,
        );
        print(
            '🏪 AuthRepository: Enhanced user data: ${enhancedUser.fullName}');
      }

      // Save token and user info
      await tokenStorage.saveToken(result.token);
      await tokenStorage.saveUserId(enhancedUser.id);
      await tokenStorage.saveUserRole(enhancedUser.role.value.toString());
      await tokenStorage.saveUserData(enhancedUser);

      print('🏪 AuthRepository: Token and user info saved successfully');

      return Right(result);
    } on ServerException catch (e) {
      print(
          '❌ AuthRepository: ServerException during registration: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print(
          '❌ AuthRepository: NetworkException during registration: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print(
          '❌ AuthRepository: AuthException during registration: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } on ValidationException catch (e) {
      print(
          '❌ AuthRepository: ValidationException during registration: ${e.message}');
      return Left(ValidationFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ AuthRepository: Unexpected error during registration: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login(
      String username, String password) async {
    print('🏪 AuthRepository: Starting login for username: $username');

    try {
      print('🏪 AuthRepository: Calling remote data source for login...');
      final result = await remoteDataSource.login(username, password);

      print('🏪 AuthRepository: Login successful!');
      print('🏪 AuthRepository: Received token: ${result.token}');
      print('🏪 AuthRepository: User ID: ${result.user.id}');
      print('🏪 AuthRepository: User role: ${result.user.role}');

      // Generate enhanced user data if some fields are missing
      UserModel enhancedUser = result.user;
      if (result.user.fullName.isEmpty ||
          result.user.location == null ||
          result.user.phone == null) {
        print(
            '🏪 AuthRepository: Enhancing user data with generated information');
        final generatedUser = UserDataService.generateUserData(
            result.user.username, result.user.email, result.user.role);

        // Merge API data with generated data, preferring API data when available
        enhancedUser = result.user.copyWith(
          fullName: result.user.fullName.isNotEmpty
              ? result.user.fullName
              : generatedUser.fullName,
          location: result.user.location ?? generatedUser.location,
          phone: result.user.phone ?? generatedUser.phone,
          jobTitle: result.user.jobTitle ?? generatedUser.jobTitle,
          workingHours: result.user.workingHours ?? generatedUser.workingHours,
        );
        print(
            '🏪 AuthRepository: Enhanced user data: ${enhancedUser.fullName}');
      }

      // Save token and user info
      await tokenStorage.saveToken(result.token);
      await tokenStorage.saveUserId(enhancedUser.id);
      await tokenStorage.saveUserRole(enhancedUser.role.value.toString());
      await tokenStorage.saveUserData(enhancedUser);

      print('🏪 AuthRepository: Token and user info saved successfully');

      return Right(result);
    } on ServerException catch (e) {
      print('❌ AuthRepository: ServerException during login: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ AuthRepository: NetworkException during login: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ AuthRepository: AuthException during login: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } on UnauthorizedException catch (e) {
      print(
          '❌ AuthRepository: UnauthorizedException during login: ${e.message}');
      return Left(UnauthorizedFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ AuthRepository: Unexpected error during login: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    print('🏪 AuthRepository: Starting logout process');

    try {
      print('🏪 AuthRepository: Calling remote data source logout...');
      await remoteDataSource.logout();

      print(
          '🏪 AuthRepository: API logout successful, clearing local storage...');
      await tokenStorage.clearAll();

      print(
          '🏪 AuthRepository: Local storage cleared, logout completed successfully');
      return const Right(null);
    } on ServerException catch (e) {
      print('❌ AuthRepository: ServerException during logout: ${e.message}');
      print('🏪 AuthRepository: Clearing local storage despite API failure...');
      await tokenStorage.clearAll();
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ AuthRepository: NetworkException during logout: ${e.message}');
      print(
          '🏪 AuthRepository: Clearing local storage despite network failure...');
      await tokenStorage.clearAll();
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ AuthRepository: AuthException during logout: ${e.message}');
      print(
          '🏪 AuthRepository: Clearing local storage despite auth failure...');
      await tokenStorage.clearAll();
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ AuthRepository: Unexpected error during logout: $e');
      print(
          '🏪 AuthRepository: Clearing local storage despite unexpected error...');
      await tokenStorage.clearAll();
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getInactiveWorkers() async {
    try {
      final result = await remoteDataSource.getInactiveWorkers();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> activateWorker(String userId) async {
    try {
      await remoteDataSource.activateWorker(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}
