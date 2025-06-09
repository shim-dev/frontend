import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

const String apiBase = 'http://210.125.91.93:5000/api/mypage';

Future<List<dynamic>?> fetchBookmarkRecipesFromDB() async {
  final userId = await getUserId(); // 또는 필요하면 매개변수로 받기
  final url = Uri.parse('$apiBase/bookmark?user_id=$userId&page=1&size=10');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['recipes'] as List<dynamic>;
    } else {
      print('❌ 북마크 불러오기 실패: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ 네트워크 오류: $e');
    return null;
  }
}

Future<bool> deleteBookmarkFromDB(int recipeId) async {
  final userId = await getUserId();
  final url = Uri.parse(
    '$apiBase/bookmark?user_id=$userId&recipe_id=$recipeId',
  );

  final response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    print('❌ 북마크 삭제 실패: ${response.statusCode}');
    return false;
  }
}
