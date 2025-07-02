part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends ProfileEvent {
  const GetCurrentUserEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final String? fullName;
  final String? phone;
  final String? location;
  final String? jobTitle;
  final String? workingHours;
  final File? profileImage;

  const UpdateProfileEvent({
    this.fullName,
    this.phone,
    this.location,
    this.jobTitle,
    this.workingHours,
    this.profileImage,
  });

  @override
  List<Object?> get props => [
        fullName,
        phone,
        location,
        jobTitle,
        workingHours,
        profileImage,
      ];
}

class DeleteProfileEvent extends ProfileEvent {
  const DeleteProfileEvent();
}

class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}
