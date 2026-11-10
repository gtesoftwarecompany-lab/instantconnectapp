import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models.dart';
import 'api_client.dart';

class WalletService extends ChangeNotifier {
  WalletService._();
  static final WalletService instance = WalletService._();

  double _balance = 0;
  List<Transaction> _txns = [];
  bool _loading = false;
  String? _error;

  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_txns);
  bool get loading => _loading;
  String? get error => _error;

  Future<void> refresh() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      // Added /api/ back to the path
      final res = await ApiClient.instance.dio.post('/api/user/index.php');

      if (res.data['status'] == 'success') {
        _balance = double.parse(res.data['balance'].toString());
      } else {
        _error = res.data['msg'] ?? 'Failed to load wallet';
      }
    } catch (e) {
      _error = _humanize(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> buyAirtime(
      {required String networkId,
      required String phone,
      required double amount}) async {
    // Added /api/ back to the path
    return _post('/api/airtime/index.php', {
      'network': networkId,
      'phone': phone,
      'amount': amount,
      'airtime_type': 'VTU'
    });
  }

  Future<bool> buyData(
      {required String networkId,
      required String phone,
      required String planId}) async {
    // Added /api/ back to the path
    return _post('/api/data/index.php', {
      'network': networkId,
      'phone': phone,
      'data_plan': planId,
    });
  }

  Future<bool> _post(String path, Map<String, dynamic> body) async {
    try {
      final res = await ApiClient.instance.dio.post(path, data: body);
      await refresh();
      return res.data['status'] == 'success';
    } catch (e) {
      _error = _humanize(e);
      notifyListeners();
      return false;
    }
  }

  String _humanize(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['msg'] != null) {
        return data['msg'].toString();
      }
      return 'Connection error. Check internet.';
    }
    return e.toString();
  }
}
