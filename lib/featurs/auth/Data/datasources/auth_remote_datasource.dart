import 'dart:io';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/models/user_model.dart';
import '../models/auth_response_model.dart';
import '../../domain/entities/register_request.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(RegisterRequest request);
  Future<AuthResponseModel> login(String username, String password);
  Future<void> logout();
  Future<List<UserModel>> getInactiveWorkers();
  Future<void> activateWorker(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseModel> register(RegisterRequest request) async {
    print('🌍 DataSource: Starting registration process');
    print('🌍 DataSource: Username: ${request.username}');
    print('🌍 DataSource: Email: ${request.email}');
    print('🌍 DataSource: Role: ${request.role}');
    print('🌍 DataSource: Has profile image: ${request.profileImage != null}');
    print('🌍 DataSource: Has ID card image: ${request.idCardImage != null}');

    final fields = <String, String>{
      'Username': request.username,
      'FullName': request.fullName,
      'Email': request.email,
      'Password': request.password,
      'Role': request.role.value.toString(),
      'Location': request.location,
      'JobTitle': request.jobTitle,
      'WorkingHours': request.workingHours,
      'Phone': request.phone,
    };

    print('🌍 DataSource: Fields to send: $fields');

    final files = <String, File>{};
    if (request.profileImage != null) {
      files['ProfileImage'] = request.profileImage!;
      print(
          '🌍 DataSource: Adding profile image: ${request.profileImage!.path}');
    }
    if (request.idCardImage != null) {
      files['IDCardImage'] = request.idCardImage!;
      print(
          '🌍 DataSource: Adding ID card image: ${request.idCardImage!.path}');
    }

    print(
        '🌍 DataSource: Making multipart request to ${ApiConstants.register}');
    final response = await apiClient.multipartRequest(
      ApiConstants.register,
      fields: fields,
      files: files.isNotEmpty ? files : null,
      requiresAuth: false,
    );

    print('🌍 DataSource: Received response: $response');
    final authResponse = AuthResponseModel.fromJson(response);
    print('🌍 DataSource: Parsed auth response successfully');

    return authResponse;
  }

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    print('🌍 DataSource: Starting login process');
    print('🌍 DataSource: Username: $username');
    print('🌍 DataSource: Password length: ${password.length}');

    // Check for hardcoded worker account
    if (username.toLowerCase() == 'mena' && password == '123456Aa@') {
      print('🌍 DataSource: Hardcoded worker account detected');
      print('🌍 DataSource: Simulating API call for worker account...');

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Create worker user model
      final workerUser = UserModel(
        id: 'worker_mena_001',
        username: 'mena',
        fullName: 'مينا عبدالمسيح',
        email: 'mena@herafy.com',
        role: UserRole.worker,
        location: 'القاهرة - مدينة نصر',
        jobTitle: 'سباك محترف',
        workingHours: '8:00 ص - 6:00 م',
        phone: '+201234567890',
        profileImageUrl: null,
        idCardImageUrl: null,
        isActive: true,
        rating: 4.8,
        reviewCount: 156,
      );

      // Create auth response
      final authResponse = AuthResponseModel(
        token:
            'hardcoded_worker_token_${DateTime.now().millisecondsSinceEpoch}',
        user: workerUser,
      );

      print('🌍 DataSource: Hardcoded worker login successful!');
      print('🌍 DataSource: Worker name: ${workerUser.fullName}');
      print('🌍 DataSource: Worker role: ${workerUser.role}');
      print('🌍 DataSource: Generated token: ${authResponse.token}');

      return authResponse;
    }

    // Regular API login for other users
    final loginBody = {
      'username': username,
      'password': password,
    };

    print('🌍 DataSource: Login body: $loginBody');
    print('🌍 DataSource: Making POST request to ${ApiConstants.login}');

    final response = await apiClient.post(
      ApiConstants.login,
      body: loginBody,
      requiresAuth: false,
    );

    print('🌍 DataSource: Received login response: $response');
    final authResponse = AuthResponseModel.fromJson(response);
    print('🌍 DataSource: Parsed login auth response successfully');

    return authResponse;
  }

  @override
  Future<void> logout() async {
    print('🌍 DataSource: Starting logout process');
    print('🌍 DataSource: Making POST request to ${ApiConstants.logout}');

    try {
      final response = await apiClient.post(
        ApiConstants.logout,
        requiresAuth: true,
      );

      print('🌍 DataSource: Logout API call successful');
      print('🌍 DataSource: Response: $response');
    } catch (e) {
      print('❌ DataSource: Logout API call failed: $e');
      // Re-throw the exception so it can be handled by the repository
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getInactiveWorkers() async {
    final response = await apiClient.get(ApiConstants.inactiveWorkers);

    final List<dynamic> workersJson = response['data'] ?? response ?? [];
    return workersJson.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<void> activateWorker(String userId) async {
    await apiClient.post('${ApiConstants.activateWorker}/$userId');
  }
}
