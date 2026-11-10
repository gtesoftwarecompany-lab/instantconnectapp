import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        // WE ARE USING A PROXY TO BYPASS FLUTLAB'S BROWSER SECURITY
        baseUrl: 'https://corsproxy.io/?https://instantconnect.vtu.name.ng',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (s) => s != null && s < 500,
      ),
    );
  }

  static final ApiClient instance = ApiClient._();
  late final Dio _dio;
  Dio get dio => _dio;

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
  }
}
