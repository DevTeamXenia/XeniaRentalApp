import 'dart:convert';
import 'api_client.dart';
import '../constants/api_urls.dart';
import '../model/dashboard_model.dart';

class DashboardApi {
  static Future<DashboardModel> fetchDashboard(int unitId) async {
    final response = await ApiClient.get(
      "${ApiUrls.dashboardHome}/$unitId",
    );

    if (response.statusCode == 200) {
      return DashboardModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to load dashboard (${response.statusCode})',
      );
    }
  }
}
