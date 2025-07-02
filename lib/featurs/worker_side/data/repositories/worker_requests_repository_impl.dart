import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/worker_requests_repository.dart';
import '../datasources/worker_requests_remote_datasource.dart';

class WorkerRequestsRepositoryImpl implements WorkerRequestsRepository {
  final WorkerRequestsRemoteDataSource remoteDataSource;

  WorkerRequestsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getMyWorkRequests() async {
    print('🏪 WorkerRequestsRepository: Getting my work requests');

    try {
      final requests = await remoteDataSource.getMyWorkRequests();

      print('🏪 WorkerRequestsRepository: Successfully retrieved ${requests.length} requests');
      return Right(requests);
    } on ServerException catch (e) {
      print('❌ WorkerRequestsRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkerRequestsRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkerRequestsRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkerRequestsRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> acceptRequest(String requestId) async {
    print('🏪 WorkerRequestsRepository: Accepting request: $requestId');

    try {
      await remoteDataSource.acceptRequest(requestId);
      print('🏪 WorkerRequestsRepository: Request accepted successfully');
      return const Right(null);
    } on ServerException catch (e) {
      print('❌ WorkerRequestsRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkerRequestsRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkerRequestsRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkerRequestsRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectRequest(String requestId) async {
    print('🏪 WorkerRequestsRepository: Rejecting request: $requestId');

    try {
      await remoteDataSource.rejectRequest(requestId);
      print('🏪 WorkerRequestsRepository: Request rejected successfully');
      return const Right(null);
    } on ServerException catch (e) {
      print('❌ WorkerRequestsRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkerRequestsRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkerRequestsRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkerRequestsRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeRequest(String requestId) async {
    print('🏪 WorkerRequestsRepository: Completing request: $requestId');

    try {
      await remoteDataSource.completeRequest(requestId);
      print('🏪 WorkerRequestsRepository: Request completed successfully');
      return const Right(null);
    } on ServerException catch (e) {
      print('❌ WorkerRequestsRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkerRequestsRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkerRequestsRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkerRequestsRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRequestHistory() async {
    print('🏪 WorkerRequestsRepository: Getting request history');

    try {
      final history = await remoteDataSource.getRequestHistory();

      print('🏪 WorkerRequestsRepository: Successfully retrieved ${history.length} history items');
      return Right(history);
    } on ServerException catch (e) {
      print('❌ WorkerRequestsRepository: ServerException: ${e.message}');
      return Left(ServerFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      print('❌ WorkerRequestsRepository: NetworkException: ${e.message}');
      return Left(NetworkFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      print('❌ WorkerRequestsRepository: AuthException: ${e.message}');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      print('❌ WorkerRequestsRepository: Unexpected error: $e');
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
} 