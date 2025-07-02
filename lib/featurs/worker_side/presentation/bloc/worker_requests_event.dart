import 'package:equatable/equatable.dart';

abstract class WorkerRequestsEvent extends Equatable {
  const WorkerRequestsEvent();

  @override
  List<Object> get props => [];
}

class GetMyWorkRequestsEvent extends WorkerRequestsEvent {
  const GetMyWorkRequestsEvent();
}

class AcceptRequestEvent extends WorkerRequestsEvent {
  final String requestId;

  const AcceptRequestEvent(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class RejectRequestEvent extends WorkerRequestsEvent {
  final String requestId;

  const RejectRequestEvent(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class CompleteRequestEvent extends WorkerRequestsEvent {
  final String requestId;

  const CompleteRequestEvent(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class GetRequestHistoryEvent extends WorkerRequestsEvent {
  const GetRequestHistoryEvent();
}

class RefreshRequestsEvent extends WorkerRequestsEvent {
  const RefreshRequestsEvent();
}
