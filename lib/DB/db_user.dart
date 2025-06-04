import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shim/DB/DB_helper.dart';

final FlutterSecureStorage _storage = FlutterSecureStorage();

// ✅ 유저 회원 가입 (유저별)
Future<void> signup({
  required String email,
  required String nickname,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$apiBase/signup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'nickname': nickname,
      'password': password,
    }),
  );
  print('[DEBUG] 서버 응답: ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final userId = data['user_id'];
    final nickName = data['nickname']; // 닉네임 파싱
    final email = data['email'];
    print('[DEBUG] 받은 user_id: $userId, nickname: $nickName');
    if (userId != null && userId.toString().isNotEmpty) {
      await _storage.write(key: 'user_id', value: userId);
      await _storage.write(key: 'nickname', value: nickName);
      await _storage.write(key: 'email', value: email);
      print('[DEBUG] user_id 저장 완료!');
    } else {
      throw Exception('서버에서 user_id를 못 받았어요!');
    }
  } else {
    throw Exception('회원가입 실패: ${response.body}');
  }
}

// ✅ 유저 로그인 (유저별)
Future<void> login({required String email, required String password}) async {
  final response = await http.post(
    Uri.parse('$apiBase/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  print('[DEBUG] 로그인 응답: ${response.body}');
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final userId = data['user_id'];
    final nickName = data['nickname'];
    final email = data['email'];
    if (userId != null && userId.toString().isNotEmpty) {
      await _storage.write(key: 'user_id', value: userId);
      await _storage.write(key: 'nickname', value: nickName);
      await _storage.write(key: 'email', value: email);
      print('[DEBUG] 로그인 user_id 저장 완료!');
    } else {
      throw Exception('서버에서 user_id를 못 받았어요!');
    }
  } else {
    // 서버에서 보낸 에러 메시지를 그대로 보여줄 수 있음
    String errMsg = '로그인 실패: ${response.body}';
    try {
      final data = jsonDecode(response.body);
      errMsg = data['error'] ?? errMsg;
    } catch (_) {}
    throw Exception(errMsg);
  }
}

// // ✅ 유저 닉네임 불러오기 (유저별) ...?? 안쓰이는 애였구나
// Future<String?> fetchNicknameFromDB() async {
//   final userId = await _storage.read(key: 'user_id');
//   if (userId == null) throw Exception('로그인 정보 없음');
//   final response = await http.get(
//     Uri.parse('$apiBase/mypage/user?user_id=$userId'),
//   );
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return data['nickname'] as String?;
//   } else {
//     throw Exception('닉네임 조회 실패: ${response.body}');
//   }
// }

// ✅ 유저 닉네임 수정하기 (유저별)
Future<void> updateNickname(String newNickname) async {
  final userId = await _storage.read(key: 'user_id');
  if (userId == null) throw Exception('로그인 정보 없음');
  final response = await http.put(
    Uri.parse('$apiBase/mypage/user'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'nickname': newNickname}),
  );
  if (response.statusCode == 200) {
    // storage의 nickname도 최신으로 갱신!
    await _storage.write(key: 'nickname', value: newNickname);
  } else {
    throw Exception('닉네임 변경 실패: ${response.body}');
  }
}
