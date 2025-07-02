import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/auth_response.dart';
import '../entities/register_request.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResponse>> call(RegisterRequest request) async {
    print(
        '🔧 RegisterUseCase: Executing registration for username: ${request.username}');
    print('🔧 RegisterUseCase: Email: ${request.email}');
    print('🔧 RegisterUseCase: Role: ${request.role}');
    final result = await repository.register(request);
    print('🔧 RegisterUseCase: Repository call completed');
    return result;
  }
}
