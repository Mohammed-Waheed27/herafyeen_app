import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class WorkerRequestsRepository {
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyWorkRequests();
  Future<Either<Failure, void>> acceptRequest(String requestId);
  Future<Either<Failure, void>> rejectRequest(String requestId);
  Future<Either<Failure, void>> completeRequest(String requestId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getRequestHistory();
}
