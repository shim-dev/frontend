import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signupUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/signup'),

    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    return {'success': true, 'user_id': decoded['user_id']}; // 여기 user_id!
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '회원가입 오류'};
  }
}
