import 'package:dio/dio.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Future<void> login({required String phone, required String password}) async {
    final data = {
      'login': '1',
      'phone': phone, 
      'password': password,
    };

    try {
      final res = await ApiClient.instance.dio.post(
        '/mobile/route.php?login', 
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      
      if (res.statusCode == 200) {
        await ApiClient.instance.saveLoginState();
      } else {
        throw Exception('Server returned status: ${res.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
         throw Exception("Server Error: ${e.response?.statusCode}");
      } else {
         throw Exception("Network Error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> logout() => ApiClient.instance.clearToken();
}
