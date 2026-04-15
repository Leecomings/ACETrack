import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final ApiService _api = ApiService();

  bool _isLoggedIn = false;
  bool _isLoading = true;
  Map<String, dynamic>? _userInfo;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userInfo => _userInfo;
  String? get nickname => _userInfo?['nickname'] ?? '网球爱好者';
  String? get myCode => _userInfo?['myCode'];
  int? get level => _userInfo?['level'] ?? 1;

  AuthProvider(this._prefs) {
    _init();
  }

  Future<void> _init() async {
    final token = _prefs.getString('token');
    final userInfoStr = _prefs.getString('userInfo');
    if (token != null) {
      _api.loadToken();
      _isLoggedIn = true;
      if (userInfoStr != null) {
        _userInfo = jsonDecode(userInfoStr);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    try {
      final res = await _api.login(phone, password);
      if (res['code'] == 0) {
        _isLoggedIn = true;
        _userInfo = res['data'];
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String phone, String password, {String? nickname}) async {
    try {
      final res = await _api.register(phone, password, nickname: nickname);
      if (res['code'] == 0) {
        _isLoggedIn = true;
        _userInfo = res['data'];
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    _isLoggedIn = false;
    _userInfo = null;
    notifyListeners();
  }

  Future<void> refreshUserInfo() async {
    try {
      final res = await _api.getUserInfo();
      if (res['code'] == 0) {
        _userInfo = res['data'];
        notifyListeners();
      }
    } catch (e) {
      // ignore
    }
  }
}
