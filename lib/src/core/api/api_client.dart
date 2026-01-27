import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {
  static Future<http.Response> get(String url) async {
    final token = await TokenStorage.getToken();
    return await http.get(
      Uri.parse(url),
      headers: {
        "accept": "*/*",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }

  static Future<http.Response> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    final token = await TokenStorage.getToken();

    return await http.post(
      Uri.parse(url),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(String url) async {
    final token = await TokenStorage.getToken();
    return await http.put(
      Uri.parse(url),
      headers: {
        "accept": "*/*",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}
