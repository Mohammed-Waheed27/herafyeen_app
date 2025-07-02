import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? location,
    String? jobTitle,
    String? workingHours,
    File? profileImage,
  });

  Future<void> deleteProfile();
  Future<bool> validateToken();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? phone,
    String? location,
    String? jobTitle,
    String? workingHours,
    File? profileImage,
  }) async {
    print('🌍 ProfileDataSource: Starting profile update');
    print('🌍 ProfileDataSource: FullName: $fullName');
    print('🌍 ProfileDataSource: Phone: $phone');
    print('🌍 ProfileDataSource: Location: $location');
    print('🌍 ProfileDataSource: JobTitle: $jobTitle');
    print('🌍 ProfileDataSource: WorkingHours: $workingHours');
    print('🌍 ProfileDataSource: Has profile image: ${profileImage != null}');

    final fields = <String, String>{};

    if (fullName != null) fields['FullName'] = fullName;
    if (phone != null) fields['Phone'] = phone;
    if (location != null) fields['Location'] = location;
    if (jobTitle != null) fields['JobTitle'] = jobTitle;
    if (workingHours != null) fields['WorkingHours'] = workingHours;

    print('🌍 ProfileDataSource: Fields to send: $fields');

    final files = <String, File>{};
    if (profileImage != null) {
      files['ProfileImage'] = profileImage;
      print('🌍 ProfileDataSource: Adding profile image: ${profileImage.path}');
    }

    print(
        '🌍 ProfileDataSource: Making multipart request to ${ApiConstants.updateProfile}');
    final response = await apiClient.multipartRequest(
      ApiConstants.updateProfile,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      requiresAuth: true,
    );

    print('🌍 ProfileDataSource: Received response: $response');

    // The API should return the updated user data
    final updatedUser = UserModel.fromJson(response['user'] ?? response);
    print('🌍 ProfileDataSource: Parsed updated user data successfully');

    return updatedUser;
  }

  @override
  Future<void> deleteProfile() async {
    print('🌍 ProfileDataSource: Starting profile deletion');

    await apiClient.delete(
      ApiConstants.deleteProfile,
      requiresAuth: true,
    );

    print('🌍 ProfileDataSource: Profile deleted successfully');
  }

  @override
  Future<bool> validateToken() async {
    print(
        '🌍 ProfileDataSource: Validating token with server using existing endpoint');

    try {
      // Use an existing authenticated endpoint to validate the token
      // Using /api/Work/my-requests since it exists in the API collection and requires auth
      await apiClient.get(
        ApiConstants.myRequests,
        requiresAuth: true,
      );

      print(
          '🌍 ProfileDataSource: Token validation successful via my-requests endpoint');
      return true;
    } catch (e) {
      print('❌ ProfileDataSource: Token validation failed: $e');

      // Check for authentication errors (401, 403) which indicate invalid token
      if (e.toString().contains('401') ||
          e.toString().contains('403') ||
          e.toString().contains('Unauthorized') ||
          e.toString().contains('Forbidden')) {
        print('🌍 ProfileDataSource: Token is invalid (auth error)');
        return false;
      }

      // For other errors (network, server), assume token is still valid
      print(
          '🌍 ProfileDataSource: Network/server error - assuming token valid');
      return true;
    }
  }
}
