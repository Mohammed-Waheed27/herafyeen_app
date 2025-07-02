import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../../core/models/user_model.dart';

class RegisterRequest extends Equatable {
  final String username;
  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final String location;
  final String jobTitle;
  final String workingHours;
  final String phone;
  final File? profileImage;
  final File? idCardImage;

  const RegisterRequest({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    required this.location,
    required this.jobTitle,
    required this.workingHours,
    required this.phone,
    this.profileImage,
    this.idCardImage,
  });

  @override
  List<Object?> get props => [
        username,
        fullName,
        email,
        password,
        role,
        location,
        jobTitle,
        workingHours,
        phone,
        profileImage,
        idCardImage,
      ];
}
