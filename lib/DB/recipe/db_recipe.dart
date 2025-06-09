import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/db_helper.dart';

// 실험실 DB상 레시피 불러오기!
Future<List<Map<String, dynamic>>> searchRecipes(
  String query, {
  String order = 'latest',
}) async {
  final response = await http.get(
    Uri.parse('$apiBase/search_recipes?query=$query&order=$order'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to search recipes');
  }
}

// 레시피 조회수 증가
Future<void> increaseRecipeView(String recipeId) async {
  final response = await http.post(
    Uri.parse('$apiBase/increase_recipe_view'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': recipeId}),
  );
  if (response.statusCode != 200) {
    print('조회수 증가 실패: ${response.body}');
  }
}

// 키워드들(해쉬태그) 들을 직접 가져오기
Future<List<String>> getKeywords() async {
  final response = await http.get(Uri.parse('$apiBase/get_keywords'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.cast<String>();
  } else {
    throw Exception('Failed to get keywords');
  }
}

// 레시피 북마크 추가
Future<void> bookmarkRecipe(String recipeId) async {
  final userId = await getUserId();
  final response = await http.post(
    Uri.parse('$apiBase/bookmark_recipe'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'recipe_id': recipeId}),
  );
  if (response.statusCode != 200) {
    throw Exception('북마크 저장 실패: ${response.body}');
  }
}
