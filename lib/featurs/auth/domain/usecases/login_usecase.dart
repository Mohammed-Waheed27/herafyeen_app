import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponse>> call(
      String username, String password) async {
    print('🔧 LoginUseCase: Executing login for username: $username');
    final result = await repository.login(username, password);
    print('🔧 LoginUseCase: Repository call completed');
    return result;
  }
}
