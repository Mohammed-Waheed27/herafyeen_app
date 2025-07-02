import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/profile_repository.dart';

class ValidateSessionUseCase {
  final ProfileRepository repository;

  ValidateSessionUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {
    print('🔧 ValidateSessionUseCase: Executing session validation');
    final result = await repository.validateSession();
    print('🔧 ValidateSessionUseCase: Repository call completed');
    return result;
  }
}
