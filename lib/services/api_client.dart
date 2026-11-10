import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        // USE YOUR REAL URL NOW (No more proxy)
        baseUrl: 'https://instantconnect.vtu.name.ng', 
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          // THIS IS THE MAGIC TRICK TO BYPASS THE 403 ERROR
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36',
        },
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
