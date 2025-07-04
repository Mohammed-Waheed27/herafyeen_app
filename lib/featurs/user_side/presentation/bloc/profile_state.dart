part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileDeleteSuccess extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
