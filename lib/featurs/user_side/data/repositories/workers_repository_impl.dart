import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/repositories/workers_repository.dart';
import '../datasources/workers_remote_datasource.dart';

class WorkersRepositoryImpl implements WorkersRepository {
  final WorkersRemoteDataSource remoteDataSource;

  WorkersRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<UserModel>>> getWorkers({
    String? jobTitle,
    String? location,
  }) async {
    print(
        '🏪 WorkersRepository: Getting workers with jobTitle: $jobTitle, location: $location');

    try {
      final workers = await remoteDataSource.getWorkers(
        jobTitle: jobTitle,
        location: location,
      );

      print(
          '🏪 WorkersRepository: Successfully retrieved ${workers.length} workers');
      return Right(workers);
    } on ServerException catch (e) {
      print('❌ WorkersRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkersRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkersRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkersRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getWorkerDetails(String workerId) async {
    print('🏪 WorkersRepository: Getting worker details for ID: $workerId');

    try {
      final worker = await remoteDataSource.getWorkerDetails(workerId);

      print(
          '🏪 WorkersRepository: Successfully retrieved worker details: ${worker.fullName}');
      return Right(worker);
    } on ServerException catch (e) {
      print('❌ WorkersRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkersRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkersRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkersRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestWork({
    required String workerId,
    required String description,
    required String location,
    required double price,
  }) async {
    print('🏪 WorkersRepository: Requesting work from worker: $workerId');

    try {
      final result = await remoteDataSource.requestWork(
        workerId: workerId,
        description: description,
        location: location,
        price: price,
      );

      print('🏪 WorkersRepository: Work request successful');
      return Right(result);
    } on ServerException catch (e) {
      print('❌ WorkersRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkersRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkersRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkersRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyRequests() async {
    print('🏪 WorkersRepository: Getting user\'s work requests');

    try {
      final requests = await remoteDataSource.getMyRequests();

      print(
          '🏪 WorkersRepository: Successfully retrieved ${requests.length} requests');
      return Right(requests);
    } on ServerException catch (e) {
      print('❌ WorkersRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkersRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkersRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkersRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}
