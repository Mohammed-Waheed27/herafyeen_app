import 'dart:io';
import '../../../../core/models/user_model.dart';

class RegistrationData {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String location;
  final UserRole role;
  final File? profileImage;
  final File? idCardImage;

  // Worker-specific fields
  final String? jobTitle;
  final String? workingHours;
  final String? yearsOfExperience;
  final String? description;
  final List<File>? portfolioImages;

  const RegistrationData({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.location,
    required this.role,
    this.profileImage,
    this.idCardImage,
    this.jobTitle,
    this.workingHours,
    this.yearsOfExperience,
    this.description,
    this.portfolioImages,
  });

  RegistrationData copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? password,
    String? location,
    UserRole? role,
    File? profileImage,
    File? idCardImage,
    String? jobTitle,
    String? workingHours,
    String? yearsOfExperience,
    String? description,
    List<File>? portfolioImages,
  }) {
    return RegistrationData(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      idCardImage: idCardImage ?? this.idCardImage,
      jobTitle: jobTitle ?? this.jobTitle,
      workingHours: workingHours ?? this.workingHours,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      description: description ?? this.description,
      portfolioImages: portfolioImages ?? this.portfolioImages,
    );
  }

  // Generate username from email or fullName
  String generateUsername() {
    if (email.isNotEmpty) {
      return email
          .split('@')
          .first
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    }
    return fullName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
  }
}
