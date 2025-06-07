import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> fetchEventDetailFromDB(String eventId) async {
  final url = Uri.parse('http://127.0.0.1:5000/api/mypage/event/$eventId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ 이벤트 상세 불러오기 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}

Future<List<dynamic>?> fetchEventsFromDB() async {
  final url = Uri.parse('http://175.192.77.229:5000/api/mypage/event');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      print('❌ 이벤트 목록 불러오기 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}
