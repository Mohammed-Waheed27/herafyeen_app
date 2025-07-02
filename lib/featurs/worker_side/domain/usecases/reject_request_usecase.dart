import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/worker_requests_repository.dart';

class RejectRequestUseCase {
  final WorkerRequestsRepository repository;

  RejectRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(String requestId) async {
    print('🔧 RejectRequestUseCase: Rejecting request: $requestId');
    
    final result = await repository.rejectRequest(requestId);
    
    print('🔧 RejectRequestUseCase: Repository call completed');
    return result;
  }
} 