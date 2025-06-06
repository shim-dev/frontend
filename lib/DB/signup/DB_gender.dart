import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setGender(String userId, String gender) async {
  final response = await http.post(
    Uri.parse('http://125.128.179.84:5000/set_gender'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'gender': gender}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '오류가 발생했습니다.'};
  }
}
