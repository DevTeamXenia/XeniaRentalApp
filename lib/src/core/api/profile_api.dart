import 'dart:convert';
import 'api_client.dart';
import '../constants/api_urls.dart';

class ProfileApi {
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


 static Future<void> disableAccount({
  required int tenantId,
}) async {
  final url = "${ApiUrls.disableTenant}?tenantId=$tenantId";

  final response = await ApiClient.put(url);

  if (response.statusCode == 200) {
    return;
  }


  if (response.body.isNotEmpty) {
    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? "Account disable failed");
  } else {
    throw Exception("Account disable failed");
  }
}


}
