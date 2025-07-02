import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../repositories/profile_repository.dart';

class GetCurrentUserUseCase {
  final ProfileRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call() async {
    print('🔧 GetCurrentUserUseCase: Executing get current user');
    final result = await repository.getCurrentUser();
    print('🔧 GetCurrentUserUseCase: Repository call completed');
    return result;
  }
}
