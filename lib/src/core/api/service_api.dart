import 'dart:convert';
import '../model/service_model.dart';
import 'api_client.dart';
import '../constants/api_urls.dart'; 
class ServiceApi {
  static Future<List<ServiceModel>> fetchServices() async {
    try {
      final response = await ApiClient.get(ApiUrls.serviceList);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ServiceModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load services (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
}
