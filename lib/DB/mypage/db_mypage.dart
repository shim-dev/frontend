import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart'; // getUserId 위치에 맞게 경로 설정

const String apiBase = 'http://125.128.179.84:5000/api/mypage';

Future<Map<String, dynamic>?> fetchUserInfo() async {
  final userId = await getUserId(); // 외부에서 전달받지 않고 내부에서 획득
  final url = Uri.parse('$apiBase/user?user_id=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print("❌ 사용자 정보 불러오기 실패: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ 에러 발생: $e");
  }
  return null;
}

Future<bool> fetchUserNotificationSetting() async {
  final userId = await getUserId();
  final url = Uri.parse('$apiBase/user?user_id=$userId');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['notificationEnabled'] ?? false;
  }
  return false;
}
