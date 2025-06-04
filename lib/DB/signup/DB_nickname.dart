import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> setNickname(String userId, String nickname, String? profileImageUrl ) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/set_nickname'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'nickname': nickname, 'profile_url': profileImageUrl}),
  );

  if (response.statusCode == 200) {
    return {'success': true};
  } else {
    final decoded = jsonDecode(response.body);
    return {
      'success': false,
      'message': decoded['message'] ?? '닉네임 저장 중 오류가 발생했습니다.',
    };
  }
}
