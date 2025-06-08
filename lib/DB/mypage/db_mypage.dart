import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart'; // getUserId 위치에 맞게 경로 설정

const String apiBase = 'http://127.0.0.1:5000/api/mypage';

Future<Map<String, dynamic>?> fetchUserInfo() async {
  final userId = await getUserId();
  final url = Uri.parse('$apiBase/user?user_id=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {
        'nickname': data['nickname'],
        'email': data['email'],
        'profileImageUrl': data['profile_url'],
      };
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

Future<bool> updateNickname(String nickname) async {
  final userId = await getUserId();
  final url = Uri.parse('http://127.0.0.1:5000/api/mypage/nickname');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'nickname': nickname}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("❌ 닉네임 변경 실패: $e");
    return false;
  }
}

Future<bool> changePassword(String currentPassword, String newPassword) async {
  final userId = await getUserId(); // 로그인된 사용자 ID 불러오기
  final url = Uri.parse('http://127.0.0.1:5000/api/mypage/change_password');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final error = json.decode(response.body)['error'];
      throw Exception(error); // 👈 Flutter 화면에서 catch 가능
    }
  } catch (e) {
    print("❌ 비밀번호 변경 오류: $e");
    throw Exception('비밀번호 변경 중 오류가 발생했습니다.');
  }
}

Future<Map<String, dynamic>?> getHeightWeight(String userId) async {
  final url = Uri.parse(
    'http://127.0.0.1:5000/api/mypage/health_profile?user_id=$userId',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('❌ 신체 정보 불러오기 실패: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
  }
  return null;
}

Future<String> fetchNickname() async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/api/mypage/user?user_id=$userId'),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['nickname'] ?? '회원';
  } else {
    return '회원';
  }
}

Future<bool> withdrawUser(String reason) async {
  final userId = await getUserId(); // SharedPreferences 등에서 가져옴
  final url = Uri.parse('http://127.0.0.1:5000/api/mypage/withdrawal');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'reason': reason}),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('❌ 회원 탈퇴 실패: $e');
    return false;
  }
}
