import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://125.128.179.84:5000/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    return {
      'success': true,
      'userId': decoded['user_id'],
      'nickname': decoded['nickname'],
    };
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '로그인 오류'};
  }
}
