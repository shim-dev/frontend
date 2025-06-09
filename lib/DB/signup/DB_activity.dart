import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setActivityLevel(
  String userId,
  String activityLevel,
) async {
  final response = await http.post(
    Uri.parse('http://210.125.91.93:5000/set_activity'),

    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'activity_level': activityLevel}),
  );
  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '활동량 저장 오류'};
  }
}
