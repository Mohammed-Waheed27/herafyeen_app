import 'package:equatable/equatable.dart';

enum UserRole { customer, worker, admin }

extension UserRoleExtension on UserRole {
  int get value {
    switch (this) {
      case UserRole.customer:
        return 0;
      case UserRole.worker:
        return 1;
      case UserRole.admin:
        return 2;
    }
  }

  static UserRole fromValue(int value) {
    switch (value) {
      case 0:
        return UserRole.customer;
      case 1:
        return UserRole.worker;
      case 2:
        return UserRole.admin;
      default:
        return UserRole.customer;
    }
  }
}

class UserModel extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final UserRole role;
  final String? location;
  final String? jobTitle;
  final String? workingHours;
  final String? phone;
  final String? profileImageUrl;
  final String? idCardImageUrl;
  final bool isActive;
  final double? rating;
  final int? reviewCount;

  const UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    this.location,
    this.jobTitle,
    this.workingHours,
    this.phone,
    this.profileImageUrl,
    this.idCardImageUrl,
    this.isActive = true,
    this.rating,
    this.reviewCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: UserRoleExtension.fromValue(json['role'] ?? 0),
      location: json['location'],
      jobTitle: json['jobTitle'],
      workingHours: json['workingHours'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      idCardImageUrl: json['idCardImageUrl'],
      isActive: json['isActive'] ?? true,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'role': role.value,
      'location': location,
      'jobTitle': jobTitle,
      'workingHours': workingHours,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'idCardImageUrl': idCardImageUrl,
      'isActive': isActive,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? fullName,
    String? email,
    UserRole? role,
    String? location,
    String? jobTitle,
    String? workingHours,
    String? phone,
    String? profileImageUrl,
    String? idCardImageUrl,
    bool? isActive,
    double? rating,
    int? reviewCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      location: location ?? this.location,
      jobTitle: jobTitle ?? this.jobTitle,
      workingHours: workingHours ?? this.workingHours,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      idCardImageUrl: idCardImageUrl ?? this.idCardImageUrl,
      isActive: isActive ?? this.isActive,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        fullName,
        email,
        role,
        location,
        jobTitle,
        workingHours,
        phone,
        profileImageUrl,
        idCardImageUrl,
        isActive,
        rating,
        reviewCount,
      ];
}
