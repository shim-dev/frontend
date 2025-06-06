import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

// 북마크 추가
// Future<void> bookmarkRecipe(String recipeId) async {
//   final userId = await getUserId();
//   final response = await http.post(
//     Uri.parse('$apiBase/bookmark_recipe'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'user_id': userId, 'recipe_id': recipeId}),
//   );
//   if (response.statusCode != 200) {
//     throw Exception('북마크 저장 실패: ${response.body}');
//   }
// }

// 레시피 id로 레시피 상세정보 받아오기
Future<Map<String, dynamic>?> getRecipeById(String recipeId) async {
  final response = await http.get(
    Uri.parse('$apiBase/get_recipe?id=$recipeId'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // 단일 객체 반환일 경우 바로 Map으로
    return Map<String, dynamic>.from(data);
  } else {
    print('[ERROR] getRecipeById: ${response.body}');
    return null;
  }
}

// 북마크(즐겨찾기) 리스트 가져오기
Future<List<Map<String, dynamic>>> getBookmarks() async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_bookmarks?user_id=$userId'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
        .toList();
  } else {
    throw Exception('Failed to get bookmarks: ${response.body}');
  }
}

// 북마크 레시피 삭제
Future<void> deleteBookmark(String recipeId) async {
  final userId = await getUserId();
  final response = await http.delete(
    Uri.parse('$apiBase/delete_bookmark?user_id=$userId&recipe_id=$recipeId'),
  );
  if (response.statusCode != 200) {
    throw Exception('북마크 삭제 실패: ${response.body}');
  }
}
