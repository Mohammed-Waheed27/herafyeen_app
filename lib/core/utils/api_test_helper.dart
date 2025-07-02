import '../network/api_client.dart';
import '../constants/api_constants.dart';

class ApiTestHelper {
  static Future<bool> testApiConnection() async {
    try {
      final apiClient = ApiClient();

      // Test a simple GET request to check if the server is reachable
      // We'll try to get inactive workers (which might return empty but should be reachable)
      await apiClient.get(
        ApiConstants.inactiveWorkers,
        requiresAuth: false, // Don't require auth for connection test
      );

      return true;
    } catch (e) {
      print('API Connection Test Failed: $e');
      return false;
    }
  }

  static Future<void> testLogin() async {
    try {
      final apiClient = ApiClient();

      final response = await apiClient.post(
        ApiConstants.login,
        body: {
          'username': 'test_user',
          'password': 'test_password',
        },
        requiresAuth: false,
      );

      print('Login Test Response: $response');
    } catch (e) {
      print('Login Test Failed: $e');
    }
  }
}
