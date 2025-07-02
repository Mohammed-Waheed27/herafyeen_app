import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import '../storage/token_storage.dart';

class ApiClient {
  final http.Client _client;
  final TokenStorage _tokenStorage;

  ApiClient({
    http.Client? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = Map<String, String>.from(ApiConstants.headers);

    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('🌐 GET Request to: $uri');
      print('📋 Headers: $headers');

      final response = await _client.get(uri, headers: headers);

      print('📥 GET Response Status: ${response.statusCode}');
      print('📥 GET Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException catch (e) {
      print('❌ SocketException in GET: $e');
      throw const NetworkException('No internet connection');
    } on HttpException catch (e) {
      print('❌ HttpException in GET: $e');
      throw const NetworkException('Network error occurred');
    } catch (e) {
      print('❌ Unexpected error in GET: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final encodedBody = body != null ? json.encode(body) : null;

      print('🌐 POST Request to: $uri');
      print('📋 Headers: $headers');
      print('📤 POST Body: $encodedBody');

      final response = await _client.post(
        uri,
        headers: headers,
        body: encodedBody,
      );

      print('📥 POST Response Status: ${response.statusCode}');
      print('📥 POST Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException catch (e) {
      print('❌ SocketException in POST: $e');
      throw const NetworkException('No internet connection');
    } on HttpException catch (e) {
      print('❌ HttpException in POST: $e');
      throw const NetworkException('Network error occurred');
    } catch (e) {
      print('❌ Unexpected error in POST: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await _client.put(
        uri,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await _client.delete(uri, headers: headers);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpException {
      throw const NetworkException('Network error occurred');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  Future<Map<String, dynamic>> multipartRequest(
    String endpoint, {
    required Map<String, String> fields,
    Map<String, File>? files,
    String method = 'POST',
    bool requiresAuth = true,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest(method, uri);

      print('🌐 MULTIPART $method Request to: $uri');
      print('📋 Fields: $fields');
      print('📁 Files: ${files?.keys.toList() ?? 'None'}');

      // Add authorization header if required
      if (requiresAuth) {
        final token = await _tokenStorage.getToken();
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
          print('🔐 Added Authorization header');
        }
      }

      // Add fields
      request.fields.addAll(fields);

      // Add files
      if (files != null) {
        for (final entry in files.entries) {
          final file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          );
          request.files.add(file);
          print('📁 Added file: ${entry.key} -> ${entry.value.path}');
        }
      }

      print('📤 Sending multipart request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 MULTIPART Response Status: ${response.statusCode}');
      print('📥 MULTIPART Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException catch (e) {
      print('❌ SocketException in MULTIPART: $e');
      throw const NetworkException('No internet connection');
    } on HttpException catch (e) {
      print('❌ HttpException in MULTIPART: $e');
      throw const NetworkException('Network error occurred');
    } catch (e) {
      print('❌ Unexpected error in MULTIPART: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParameters]) {
    final fullUrl = '${ApiConstants.baseUrl}$endpoint';
    final uri = Uri.parse(fullUrl);

    print('🔗 Building URI: $fullUrl');

    if (queryParameters != null && queryParameters.isNotEmpty) {
      final finalUri = uri.replace(queryParameters: queryParameters);
      print('🔗 Final URI with query params: $finalUri');
      return finalUri;
    }

    return uri;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    print('🔍 Handling response with status: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        print('✅ Success response received');
        if (response.body.isEmpty) {
          return {'success': true};
        }
        try {
          final decodedResponse = json.decode(response.body);
          print('✅ Decoded response: $decodedResponse');
          return decodedResponse;
        } catch (e) {
          print('⚠️ Failed to decode JSON, returning raw body: $e');
          return {'success': true, 'data': response.body};
        }
      case 400:
        final errorMessage = _extractErrorMessage(response.body);
        print('❌ Bad Request (400): $errorMessage');
        throw BadRequestException(
          errorMessage,
          code: response.statusCode.toString(),
        );
      case 401:
        print('❌ Unauthorized (401): ${response.body}');
        throw UnauthorizedException(_extractErrorMessage(response.body));
      case 403:
        print('❌ Forbidden (403): ${response.body}');
        throw ForbiddenException(_extractErrorMessage(response.body));
      case 404:
        print('❌ Not Found (404): ${response.body}');
        throw NotFoundException(_extractErrorMessage(response.body));
      case 500:
        print('❌ Internal Server Error (500): ${response.body}');
        throw InternalServerException(_extractErrorMessage(response.body));
      default:
        final errorMessage =
            'Server error: ${response.statusCode} - ${response.body}';
        print('❌ Unknown error: $errorMessage');
        throw ServerException(
          errorMessage,
          code: response.statusCode.toString(),
        );
    }
  }

  String _extractErrorMessage(String responseBody) {
    print('🔍 Extracting error message from: $responseBody');
    try {
      final json = jsonDecode(responseBody);
      print('🔍 Parsed error JSON: $json');

      // Try different common error message fields
      final message = json['message'] ??
          json['error'] ??
          json['errors'] ??
          json['detail'] ??
          json['title'] ??
          'Unknown error occurred';

      print('🔍 Extracted error message: $message');
      return message.toString();
    } catch (e) {
      print('⚠️ Failed to parse error JSON: $e');
      // Return the raw response body if JSON parsing fails
      return responseBody.isNotEmpty ? responseBody : 'Server error occurred';
    }
  }

  void dispose() {
    _client.close();
  }
}
