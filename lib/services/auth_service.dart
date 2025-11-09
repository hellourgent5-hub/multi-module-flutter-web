import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? userEmail;
  String? userRole;
  String? userId;

  bool get isAuth => _token != null;

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'token');
    final role = await _storage.read(key: 'role');
    final id = await _storage.read(key: 'id');
    final email = await _storage.read(key: 'email');
    if (token == null) return;
    _token = token;
    userRole = role;
    userEmail = email;
    userId = id;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final res = await ApiService.post('/auth/login', {'email': email, 'password': password});
    _token = res['token'];
    userEmail = res['user']?['email'];
    userRole = res['user']?['role'];
    userId = res['user']?['id'] ?? res['user']?['_id'];
    await _storage.write(key: 'token', value: _token);
    await _storage.write(key: 'role', value: userRole ?? '');
    await _storage.write(key: 'email', value: userEmail ?? '');
    await _storage.write(key: 'id', value: userId ?? '');
    notifyListeners();
  }

  Future<void> register(String name, String email, String password, String role) async {
    final res = await ApiService.post('/auth/register', {'name': name, 'email': email, 'password': password, 'role': role});
    _token = res['token'];
    userEmail = res['user']?['email'];
    userRole = res['user']?['role'];
    userId = res['user']?['id'] ?? res['user']?['_id'];
    await _storage.write(key: 'token', value: _token);
    await _storage.write(key: 'role', value: userRole ?? '');
    await _storage.write(key: 'email', value: userEmail ?? '');
    await _storage.write(key: 'id', value: userId ?? '';
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    userRole = null;
    userEmail = null;
    userId = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  Map<String, String> get authHeader => {
        'Authorization': 'Bearer $_token',
      };
}
