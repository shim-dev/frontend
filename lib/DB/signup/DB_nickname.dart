import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

Future<Map<String, dynamic>> setNickname(
  String userId,
  String nickname,
  String? profileImageUrl,
) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/set_nickname'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'nickname': nickname,
      'profile_url': profileImageUrl,
    }),
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

// 닉네임 불러오기
Future<String> fetchNicknameFromServer() async {
  final userId = await getUserId();
  final response = await http.post(
    Uri.parse('$apiBase/get_nickname'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      return data['nickname'] ?? '사용자';
    }
  }

  return '사용자';
}
