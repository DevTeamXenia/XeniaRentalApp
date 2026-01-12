import 'dart:convert';
import 'api_client.dart';
import '../constants/api_urls.dart';

class ProfileApi {
  /// Fetch tenant profile
  static Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await ApiClient.get(ApiUrls.profileList);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load profile (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
}
