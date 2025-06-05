import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiBase = 'http://175.192.77.229:5000/api/mypage';

Future<List<dynamic>?> fetchNoticesFromDB() async {
  final url = Uri.parse('$apiBase/notice');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      print('❌ 공지사항 불러오기 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchNoticeDetailFromDB(String noticeId) async {
  final url = Uri.parse('$apiBase/notice/$noticeId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('❌ 공지 상세 조회 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}
