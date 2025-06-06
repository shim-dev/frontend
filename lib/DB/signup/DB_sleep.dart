import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setSleepTime(String userId, int sleepHour) async {
  final response = await http.post(
    Uri.parse('http://125.128.179.84:5000/set_sleep'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'sleep_hour': sleepHour}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '수면 시간 저장 오류'};
  }
}
