import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setAlcohol(String userId, int alcoholCup) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/set_alcohol'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'alcohol_cup': alcoholCup}),
  );
  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '오류가 발생했습니다.'};
  }
}
