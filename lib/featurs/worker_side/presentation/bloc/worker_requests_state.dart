import 'package:equatable/equatable.dart';

abstract class WorkerRequestsState extends Equatable {
  const WorkerRequestsState();

  @override
  List<Object> get props => [];
}

class WorkerRequestsInitial extends WorkerRequestsState {
  const WorkerRequestsInitial();
}

class WorkerRequestsLoading extends WorkerRequestsState {
  const WorkerRequestsLoading();
}

class WorkerRequestsLoaded extends WorkerRequestsState {
  final List<Map<String, dynamic>> requests;

  const WorkerRequestsLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class WorkerRequestsError extends WorkerRequestsState {
  final String message;

  const WorkerRequestsError(this.message);

  @override
  List<Object> get props => [message];
}

class RequestActionLoading extends WorkerRequestsState {
  final String requestId;
  final String action; // 'accept' or 'reject'

  const RequestActionLoading(this.requestId, this.action);

  @override
  List<Object> get props => [requestId, action];
}

class RequestActionSuccess extends WorkerRequestsState {
  final String message;
  final String requestId;
  final String action;

  const RequestActionSuccess(this.message, this.requestId, this.action);

  @override
  List<Object> get props => [message, requestId, action];
}

class RequestHistoryLoaded extends WorkerRequestsState {
  final List<Map<String, dynamic>> history;

  const RequestHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
} 