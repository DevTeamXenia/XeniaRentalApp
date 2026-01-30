import 'dart:convert';
import '../constants/api_urls.dart';
import 'api_client.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  
static Future<String?> generateOtp(String phone) async {
  try {
    final response = await ApiClient.post(
      ApiUrls.loginOtp,
      {
        "CompanyID": 4,
        "MobileNo": phone,
        "Email": "string",
      },
    );

    if (response.statusCode == 200) {
      return null;
    }

    if (response.statusCode == 401) {
      final body = response.body;
      return body.contains("message")
          ? body
              .replaceAll(RegExp(r'[{}"]'), '')
              .split(':')
              .last
              .trim()
          : "Phone number not registered";
    }

    return "Something went wrong. Please try again.";
  } catch (e) {
    return "Server error. Please try again.";
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
        "&companyId=4"
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
