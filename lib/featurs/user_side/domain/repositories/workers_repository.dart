import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';

abstract class WorkersRepository {
  Future<Either<Failure, List<UserModel>>> getWorkers({
    String? jobTitle,
    String? location,
  });

  Future<Either<Failure, UserModel>> getWorkerDetails(String workerId);

  Future<Either<Failure, Map<String, dynamic>>> requestWork({
    required String workerId,
    required String description,
    required String location,
    required double price,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getMyRequests();
}
