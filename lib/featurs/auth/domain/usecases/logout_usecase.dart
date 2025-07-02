import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    print('🔧 LogoutUseCase: Executing logout');
    final result = await repository.logout();
    print('🔧 LogoutUseCase: Repository call completed');
    return result;
  }
}
