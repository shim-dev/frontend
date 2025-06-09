import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>?> fetchFaqsFromDB() async {
  final url = Uri.parse('http://210.125.91.93:5000/api/mypage/faq');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      print('❌ FAQ 불러오기 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}
