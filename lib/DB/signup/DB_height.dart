import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setHeightWeight(
  String userId,
  int height,
  int weight,
) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/set_height_weight'),

    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'height': height, 'weight': weight}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {'success': false, 'message': decoded['message'] ?? '저장 중 오류'};
  }
}
