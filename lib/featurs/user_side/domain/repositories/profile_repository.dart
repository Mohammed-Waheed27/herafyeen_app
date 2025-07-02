import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> updateProfile({
    String? fullName,
    String? phone,
    String? location,
    String? jobTitle,
    String? workingHours,
    File? profileImage,
  });

  Future<Either<Failure, void>> deleteProfile();
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, bool>> validateSession();
}
