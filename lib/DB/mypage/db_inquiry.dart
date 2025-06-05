import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>?> fetchInquiriesFromDB(String userId) async {
  final url = Uri.parse(
    'http://175.192.77.229:5000/api/mypage/inquiries?user_id=$userId',
  );

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
