import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../repositories/workers_repository.dart';

class GetWorkersUseCase {
  final WorkersRepository repository;

  GetWorkersUseCase(this.repository);

  Future<Either<Failure, List<UserModel>>> call({
    String? jobTitle,
    String? location,
  }) async {
    print('🔧 GetWorkersUseCase: Executing get workers');
    print('🔧 GetWorkersUseCase: JobTitle: $jobTitle, Location: $location');

    final result = await repository.getWorkers(
      jobTitle: jobTitle,
      location: location,
    );

    print('🔧 GetWorkersUseCase: Repository call completed');
    return result;
  }
}
