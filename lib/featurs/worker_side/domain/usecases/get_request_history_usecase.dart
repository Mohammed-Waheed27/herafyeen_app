import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/worker_requests_repository.dart';

class GetRequestHistoryUseCase {
  final WorkerRequestsRepository repository;

  GetRequestHistoryUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    print('🔧 GetRequestHistoryUseCase: Getting request history');
    
    final result = await repository.getRequestHistory();
    
    print('🔧 GetRequestHistoryUseCase: Repository call completed');
    return result;
  }
} 