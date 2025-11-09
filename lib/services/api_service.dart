import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String baseUrl =
      dotenv.env['API_BASE'] ?? 'https://success-backend-98io.onrender.com/api';

  static Future<Map<String, dynamic>> post(String path, Map body, {Map<String,String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    });
    return _process(res);
  }

  static Future<dynamic> get(String path, {Map<String,String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final res = await http.get(uri, headers: headers);
    return _process(res);
  }

  static dynamic _process(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {'statusCode': res.statusCode};
      try {
        return jsonDecode(res.body);
      } catch (_) {
        return res.body;
      }
    } else {
      String msg = res.body;
      try { msg = jsonDecode(res.body)['message'] ?? res.body; } catch (_) {}
      throw Exception('HTTP ${res.statusCode}: $msg');
    }
  }
}
