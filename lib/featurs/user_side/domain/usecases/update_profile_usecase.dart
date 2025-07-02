import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserModel>> call({
    String? fullName,
    String? phone,
    String? location,
    String? jobTitle,
    String? workingHours,
    File? profileImage,
  }) async {
    print('🔧 UpdateProfileUseCase: Executing profile update');
    print('🔧 UpdateProfileUseCase: FullName: $fullName');
    print('🔧 UpdateProfileUseCase: Phone: $phone');

    final result = await repository.updateProfile(
      fullName: fullName,
      phone: phone,
      location: location,
      jobTitle: jobTitle,
      workingHours: workingHours,
      profileImage: profileImage,
    );

    print('🔧 UpdateProfileUseCase: Repository call completed');
    return result;
  }
}
