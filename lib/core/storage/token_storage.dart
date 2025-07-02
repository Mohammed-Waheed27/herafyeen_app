import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _userDataKey = 'user_data';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print(
        '💾 TokenStorage: Saved token: ${token.length > 10 ? '${token.substring(0, 10)}...' : token}');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print(
        '💾 TokenStorage: Retrieved token: ${token != null ? (token.length > 10 ? '${token.substring(0, 10)}...' : token) : 'null'}');
    return token;
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    await prefs.setString(_userDataKey, userJson);
    print('💾 TokenStorage: Saved user data: ${user.fullName}');
  }

  Future<UserModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userDataKey);

    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        final user = UserModel.fromJson(userMap);
        print('💾 TokenStorage: Retrieved user data: ${user.fullName}');
        return user;
      } catch (e) {
        print('❌ TokenStorage: Error parsing user data: $e');
        return null;
      }
    }

    print('💾 TokenStorage: No user data found');
    return null;
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    final hasToken = token != null && token.isNotEmpty;
    print('💾 TokenStorage: Has token check: $hasToken');
    return hasToken;
  }

  Future<bool> hasUserData() async {
    final userData = await getUserData();
    final hasUserData = userData != null;
    print('💾 TokenStorage: Has user data check: $hasUserData');
    return hasUserData;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userDataKey);
    print('💾 TokenStorage: Cleared all data');
  }
}
