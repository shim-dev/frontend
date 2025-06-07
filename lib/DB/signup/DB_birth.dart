import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setBirth(String userId, String birth) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/set_birth'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'birth': birth}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '생년월일 저장 오류'};
  }
}
