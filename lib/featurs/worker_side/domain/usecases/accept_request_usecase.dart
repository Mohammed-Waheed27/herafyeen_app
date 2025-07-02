import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/worker_requests_repository.dart';

class AcceptRequestUseCase {
  final WorkerRequestsRepository repository;

  AcceptRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) async {
    print('🔧 AcceptRequestUseCase: Accepting request: $requestId');

    final result = await repository.acceptRequest(requestId);

    print('🔧 AcceptRequestUseCase: Repository call completed');
    return result;
  }
}
