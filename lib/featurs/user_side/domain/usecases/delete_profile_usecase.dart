import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/profile_repository.dart';

class DeleteProfileUseCase {
  final ProfileRepository repository;

  DeleteProfileUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    print('🔧 DeleteProfileUseCase: Executing profile deletion');
    final result = await repository.deleteProfile();
    print('🔧 DeleteProfileUseCase: Repository call completed');
    return result;
  }
} 