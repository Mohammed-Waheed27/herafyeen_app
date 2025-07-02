import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/worker_requests_repository.dart';

class GetMyWorkRequestsUseCase {
  final WorkerRequestsRepository repository;

  GetMyWorkRequestsUseCase(this.repository);

  Future<Either<Failure, List<Map<String, dynamic>>>> call() async {
    print('🔧 GetMyWorkRequestsUseCase: Getting worker\'s work requests');

    final result = await repository.getMyWorkRequests();

    print('🔧 GetMyWorkRequestsUseCase: Repository call completed');
    return result;
  }
}
