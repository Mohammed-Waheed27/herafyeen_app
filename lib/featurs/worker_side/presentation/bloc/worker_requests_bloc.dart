import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_work_requests_usecase.dart';
import '../../domain/usecases/accept_request_usecase.dart';
import '../../domain/usecases/reject_request_usecase.dart';
import '../../domain/usecases/complete_request_usecase.dart';
import '../../domain/usecases/get_request_history_usecase.dart';
import 'worker_requests_event.dart';
import 'worker_requests_state.dart';

class WorkerRequestsBloc
    extends Bloc<WorkerRequestsEvent, WorkerRequestsState> {
  final GetMyWorkRequestsUseCase getMyWorkRequestsUseCase;
  final AcceptRequestUseCase acceptRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;
  final CompleteRequestUseCase completeRequestUseCase;
  final GetRequestHistoryUseCase getRequestHistoryUseCase;

  WorkerRequestsBloc({
    required this.getMyWorkRequestsUseCase,
    required this.acceptRequestUseCase,
    required this.rejectRequestUseCase,
    required this.completeRequestUseCase,
    required this.getRequestHistoryUseCase,
  }) : super(const WorkerRequestsInitial()) {
    on<GetMyWorkRequestsEvent>(_onGetMyWorkRequests);
    on<AcceptRequestEvent>(_onAcceptRequest);
    on<RejectRequestEvent>(_onRejectRequest);
    on<CompleteRequestEvent>(_onCompleteRequest);
    on<GetRequestHistoryEvent>(_onGetRequestHistory);
    on<RefreshRequestsEvent>(_onRefreshRequests);
  }

  Future<void> _onGetMyWorkRequests(
    GetMyWorkRequestsEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print('🔧 WorkerRequestsBloc: Get my work requests event received');

    emit(const WorkerRequestsLoading());
    print('🔧 WorkerRequestsBloc: Emitted WorkerRequestsLoading state');

    final result = await getMyWorkRequestsUseCase();

    print('🔧 WorkerRequestsBloc: Received result from use case');
    result.fold(
      (failure) {
        print('❌ WorkerRequestsBloc: Get requests failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (requests) {
        print(
            '✅ WorkerRequestsBloc: Get requests successful! Count: ${requests.length}');
        emit(WorkerRequestsLoaded(requests));
      },
    );
  }

  Future<void> _onAcceptRequest(
    AcceptRequestEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print(
        '🔧 WorkerRequestsBloc: Accept request event received: ${event.requestId}');

    emit(RequestActionLoading(event.requestId, 'accept'));
    print('🔧 WorkerRequestsBloc: Emitted RequestActionLoading state');

    final result = await acceptRequestUseCase(event.requestId);

    print('🔧 WorkerRequestsBloc: Received result from accept use case');
    result.fold(
      (failure) {
        print(
            '❌ WorkerRequestsBloc: Accept request failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (_) {
        print('✅ WorkerRequestsBloc: Accept request successful!');
        emit(const RequestActionSuccess(
          'تم قبول الطلب بنجاح',
          '',
          'accept',
        ));
        // Refresh the requests list after successful action
        add(const GetMyWorkRequestsEvent());
      },
    );
  }

  Future<void> _onRejectRequest(
    RejectRequestEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print(
        '🔧 WorkerRequestsBloc: Reject request event received: ${event.requestId}');

    emit(RequestActionLoading(event.requestId, 'reject'));
    print('🔧 WorkerRequestsBloc: Emitted RequestActionLoading state');

    final result = await rejectRequestUseCase(event.requestId);

    print('🔧 WorkerRequestsBloc: Received result from reject use case');
    result.fold(
      (failure) {
        print(
            '❌ WorkerRequestsBloc: Reject request failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (_) {
        print('✅ WorkerRequestsBloc: Reject request successful!');
        emit(const RequestActionSuccess(
          'تم رفض الطلب',
          '',
          'reject',
        ));
        // Refresh the requests list after successful action
        add(const GetMyWorkRequestsEvent());
      },
    );
  }

  Future<void> _onCompleteRequest(
    CompleteRequestEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print(
        '🔧 WorkerRequestsBloc: Complete request event received: ${event.requestId}');

    emit(RequestActionLoading(event.requestId, 'complete'));
    print('🔧 WorkerRequestsBloc: Emitted RequestActionLoading state');

    final result = await completeRequestUseCase(event.requestId);

    print('🔧 WorkerRequestsBloc: Received result from complete use case');
    result.fold(
      (failure) {
        print(
            '❌ WorkerRequestsBloc: Complete request failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (_) {
        print('✅ WorkerRequestsBloc: Complete request successful!');
        emit(const RequestActionSuccess(
          'تم إكمال الطلب بنجاح',
          '',
          'complete',
        ));
        // Refresh the requests list after successful action
        add(const GetMyWorkRequestsEvent());
      },
    );
  }

  Future<void> _onGetRequestHistory(
    GetRequestHistoryEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print('🔧 WorkerRequestsBloc: Get request history event received');

    emit(const WorkerRequestsLoading());
    print('🔧 WorkerRequestsBloc: Emitted WorkerRequestsLoading state');

    final result = await getRequestHistoryUseCase();

    print('🔧 WorkerRequestsBloc: Received result from history use case');
    result.fold(
      (failure) {
        print('❌ WorkerRequestsBloc: Get history failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (history) {
        print(
            '✅ WorkerRequestsBloc: Get history successful! Count: ${history.length}');
        emit(RequestHistoryLoaded(history));
      },
    );
  }

  Future<void> _onRefreshRequests(
    RefreshRequestsEvent event,
    Emitter<WorkerRequestsState> emit,
  ) async {
    print('🔧 WorkerRequestsBloc: Refresh requests event received');

    // For refresh, we don't show loading state to avoid UI flash
    final result = await getMyWorkRequestsUseCase();

    print('🔧 WorkerRequestsBloc: Received result from refresh use case');
    result.fold(
      (failure) {
        print('❌ WorkerRequestsBloc: Refresh failed: ${failure.message}');
        emit(WorkerRequestsError(failure.message));
      },
      (requests) {
        print(
            '✅ WorkerRequestsBloc: Refresh successful! Count: ${requests.length}');
        emit(WorkerRequestsLoaded(requests));
      },
    );
  }
}
