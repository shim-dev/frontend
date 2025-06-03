import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setCaffeineCups(String userId, int caffeineCup) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/set_caffeine'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'caffeine_cup': caffeineCup}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {
      'success': false,
      'message': decoded['message'] ?? '카페인 정보 저장 오류',
    };
  }
}
