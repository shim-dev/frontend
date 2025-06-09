import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

const String apiBase = 'http://210.125.91.93:5000/api/mypage';

// 🔹 1:1 문의 내역 불러오기
Future<List<dynamic>?> fetchInquiriesFromDB() async {
  final userId = await getUserId();
  if (userId == null) {
    print('❌ 사용자 ID 없음');
    return null;
  }

  final url = Uri.parse('$apiBase/inquiries?user_id=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      print('❌ 1:1 문의 목록 조회 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}

//  1:1 문의 등록
Future<bool> postInquiryToDB(String title, String content) async {
  final userId = await getUserId(); // ✅ 동적으로 불러오기
  if (userId == null) {
    print('❌ 사용자 ID 없음');
    return false;
  }

  final url = Uri.parse('$apiBase/inquiries');
  final body = jsonEncode({
    'user_id': userId,
    'title': title,
    'content': content,
  });

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response.statusCode == 200;
  } catch (e) {
    print('❌ 문의 등록 실패: $e');
    return false;
  }
}
