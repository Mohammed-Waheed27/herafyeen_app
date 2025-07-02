import 'dart:io';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? fullName,
    String? phone,
    String? location,
    String? jobTitle,
    String? workingHours,
    File? profileImage,
  }) async {
    print('🏪 ProfileRepository: Starting profile update');
    print('🏪 ProfileRepository: FullName: $fullName');
    print('🏪 ProfileRepository: Phone: $phone');

    try {
      print(
          '🏪 ProfileRepository: Calling remote data source for profile update...');
      final result = await remoteDataSource.updateProfile(
        fullName: fullName,
        phone: phone,
        location: location,
        jobTitle: jobTitle,
        workingHours: workingHours,
        profileImage: profileImage,
      );

      print('🏪 ProfileRepository: Profile update successful!');
      print('🏪 ProfileRepository: Updated user: ${result.fullName}');

      // Save updated user data locally
      await tokenStorage.saveUserData(result);
      print('🏪 ProfileRepository: Updated user data saved locally');

      return Right(result);
    } on ServerException catch (e) {
      print(
          '❌ ProfileRepository: ServerException during profile update: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print(
          '❌ ProfileRepository: NetworkException during profile update: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print(
          '❌ ProfileRepository: AuthException during profile update: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } on ValidationException catch (e) {
      print(
          '❌ ProfileRepository: ValidationException during profile update: ${e.message}');
      return Left(ValidationFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ ProfileRepository: Unexpected error during profile update: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    print('🏪 ProfileRepository: Starting profile deletion');

    try {
      print(
          '🏪 ProfileRepository: Calling remote data source for profile deletion...');
      await remoteDataSource.deleteProfile();

      print('🏪 ProfileRepository: Profile deletion successful!');

      // Clear all local data after successful deletion
      await tokenStorage.clearAll();
      print('🏪 ProfileRepository: Local data cleared');

      return const Right(null);
    } on ServerException catch (e) {
      print(
          '❌ ProfileRepository: ServerException during profile deletion: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print(
          '❌ ProfileRepository: NetworkException during profile deletion: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print(
          '❌ ProfileRepository: AuthException during profile deletion: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print(
          '❌ ProfileRepository: Unexpected error during profile deletion: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    print('🏪 ProfileRepository: Getting current user data');

    try {
      final userData = await tokenStorage.getUserData();

      if (userData != null) {
        print(
            '🏪 ProfileRepository: Found local user data: ${userData.fullName}');
        return Right(userData);
      } else {
        print('❌ ProfileRepository: No local user data found');
        return const Left(
            AuthFailure('No user data found. Please login again.'));
      }
    } catch (e) {
      print('❌ ProfileRepository: Error getting current user: $e');
      return Left(ServerFailure('Error retrieving user data: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateSession() async {
    print('🏪 ProfileRepository: Validating session');

    try {
      // First check if we have local token and user data
      final hasToken = await tokenStorage.hasToken();
      final hasUserData = await tokenStorage.hasUserData();

      if (!hasToken || !hasUserData) {
        print('🏪 ProfileRepository: Missing local session data');
        return const Right(false);
      }

      // Then validate with server
      final isValid = await remoteDataSource.validateToken();

      if (isValid) {
        print('🏪 ProfileRepository: Session validation successful');
      } else {
        print(
            '🏪 ProfileRepository: Session validation failed - clearing local data');
        await tokenStorage.clearAll();
      }

      return Right(isValid);
    } on ServerException catch (e) {
      print(
          '❌ ProfileRepository: ServerException during session validation: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print(
          '❌ ProfileRepository: NetworkException during session validation: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print(
          '❌ ProfileRepository: AuthException during session validation: ${e.message}');
      // Clear local data on auth failure
      await tokenStorage.clearAll();
      return const Right(false);
    } catch (e) {
      print(
          '❌ ProfileRepository: Unexpected error during session validation: $e');
      return Left(ServerFailure('Error validating session: $e'));
    }
  }
}
