import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/worker_requests_repository.dart';

class CompleteRequestUseCase {
  final WorkerRequestsRepository repository;

  CompleteRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) async {
    print('🔧 CompleteRequestUseCase: Completing request: $requestId');

    final result = await repository.completeRequest(requestId);

    print('🔧 CompleteRequestUseCase: Repository call completed');
    return result;
  }
}
