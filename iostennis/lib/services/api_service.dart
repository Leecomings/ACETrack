import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://47.99.192.50:3000';
  // 生产环境: 'https://api.tenniseye.com/api/v1'
  static const String apiV1 = '$baseUrl/api';

  String? _token;
  String? get token => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userInfo');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    Uri url = Uri.parse('$apiV1$path');
    if (query != null && query.isNotEmpty) {
      url = url.replace(queryParameters: query.map((k, v) => MapEntry(k, v.toString())));
    }
    final res = await http.get(url, headers: _headers);
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$apiV1$path');
    final res = await http.post(url, headers: _headers, body: jsonEncode(body));
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$apiV1$path');
    final res = await http.put(url, headers: _headers, body: jsonEncode(body));
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final url = Uri.parse('$apiV1$path');
    final res = await http.delete(url, headers: _headers);
    return _handleResponse(res);
  }

  Map<String, dynamic> _handleResponse(http.Response res) {
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 401) {
      clearToken();
      throw Exception('登录已过期，请重新登录');
    }
    return data;
  }

  // ========== Auth API ==========
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final res = await post('/auth/login', body: {'phone': phone, 'password': password});
    if (res['code'] == 0) {
      await _saveToken(res['data']['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userInfo', jsonEncode(res['data']));
    }
    return res;
  }

  Future<Map<String, dynamic>> register(String phone, String password, {String? nickname}) async {
    final res = await post('/auth/register', body: {
      'phone': phone,
      'password': password,
      if (nickname != null) 'nickname': nickname,
    });
    if (res['code'] == 0) {
      await _saveToken(res['data']['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userInfo', jsonEncode(res['data']));
    }
    return res;
  }

  Future<Map<String, dynamic>> sendSmsCode(String phone) async {
    return post('/sms/send', body: {'phone': phone});
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    return get('/user/info');
  }

  Future<Map<String, dynamic>> updateUserInfo({String? nickname, String? avatar}) async {
    return post('/user/update', body: {
      if (nickname != null) 'nickname': nickname,
      if (avatar != null) 'avatar': avatar,
    });
  }

  // ========== Friend API ==========
  Future<Map<String, dynamic>> findFriendByCode(String code) async {
    return post('/friend/find-by-code', body: {'targetCode': code});
  }

  Future<Map<String, dynamic>> getFriendList() async {
    return get('/friend/list');
  }
}
