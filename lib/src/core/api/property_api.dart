import 'dart:convert';
import '../model/property_model.dart';
import 'api_client.dart';
import '../constants/api_urls.dart';

class PropertyApi {
  static Future<List<PropertyModel>> fetchProperties() async {
    final response = await ApiClient.get(ApiUrls.propertyList);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map<PropertyModel>((e) => PropertyModel.fromJson(e))
          .toList();
    } else {
      throw Exception(
        'Failed to load properties (${response.statusCode})',
      );
    }
  }
}
