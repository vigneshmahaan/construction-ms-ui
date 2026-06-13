import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Use 10.0.2.2 for Android Emulator, localhost for Web/iOS
  // Using 10.0.2.2 directly since Android emulator is the primary target
  static const String baseUrl = 'http://10.0.2.2:3000';

  static String? currentUserId;
  static String? currentCompanyId;

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: _headers());
      return _processResponse(response);
    } catch (e) {
      debugPrint('GET Error: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint('POST Error: $e');
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint('PUT Error: $e');
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.patch(
        url,
        headers: _headers(),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint('PATCH Error: $e');
      rethrow;
    }
  }

  Map<String, String> _headers() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (currentUserId != null) headers['x-user-id'] = currentUserId!;
    if (currentCompanyId != null) headers['x-company-id'] = currentCompanyId!;

    return headers;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
      return null;
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
