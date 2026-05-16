import 'package:equatable/equatable.dart';

abstract class AccessRequestState extends Equatable {
  const AccessRequestState();

  @override
  List<Object?> get props => [];
}

class AccessRequestInitial extends AccessRequestState {
  const AccessRequestInitial();
}

class AccessRequestLoading extends AccessRequestState {
  const AccessRequestLoading();
}

class AccessRequestSuccess extends AccessRequestState {
  final String leadName;

  const AccessRequestSuccess(this.leadName);

  @override
  List<Object?> get props => [leadName];
}

class AccessRequestError extends AccessRequestState {
  final String message;

  const AccessRequestError(this.message);

  @override
  List<Object?> get props => [message];
}
