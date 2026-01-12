import 'dart:convert';
import '../constants/api_urls.dart';
import 'api_client.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static Future<bool> generateOtp(String phone) async {
    try {
      final response = await ApiClient.post(
        ApiUrls.loginOtp,
        {
          "CompanyID": 1,
          "MobileNo": phone,
          "Email": "string",
        },
      );

      if (response.statusCode == 200) {
        final body = response.body.toLowerCase();
        return body.contains("otp sent");
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse(
        "${ApiUrls.baseUrl}/Auth/login"
        "?userName=$phone"
        "&password=$phone"
        "&companyId=1"
        "&otp=$otp"
        "&deviceToken=hj",
      );

      final response = await http.post(
        uri,
        headers: {"accept": "*/*"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["Status"] == "Success") {
          return data["Token"]; 
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
