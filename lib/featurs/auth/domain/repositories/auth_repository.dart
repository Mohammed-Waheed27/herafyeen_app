import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../entities/auth_response.dart';
import '../entities/register_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);
  Future<Either<Failure, AuthResponse>> login(String username, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, List<UserModel>>> getInactiveWorkers();
  Future<Either<Failure, void>> activateWorker(String userId);
}
