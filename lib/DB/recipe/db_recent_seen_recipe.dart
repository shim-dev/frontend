import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

// 최근에 본 레시피 ID 저장
Future<void> addRecentRecipe(String recipeId) async {
  final userId = await getUserId();
  final response = await http.post(
    Uri.parse('$apiBase/add_recent'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'recipe_id': recipeId}),
  );
  if (response.statusCode != 200) {
    print('❌ 최근 본 레시피 저장 실패: ${response.body}');
  }
}

// 최근에 본 레시피 리스트 가져오기
Future<List<Map<String, dynamic>>> getRecentRecipes() async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_recent?user_id=$userId'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
  } else {
    throw Exception('❌ 최근 본 레시피 불러오기 실패: ${response.body}');
  }
}

// 최근에 본 레시피 삭제하기
Future<void> deleteRecentRecipe(String recipeId) async {
  final userId = await getUserId();
  final response = await http.delete(
    Uri.parse('$apiBase/delete_recent?user_id=$userId&recipe_id=$recipeId'),
  );
  if (response.statusCode != 200) {
    throw Exception('최근 본 레시피 삭제 실패: ${response.body}');
  }
}
