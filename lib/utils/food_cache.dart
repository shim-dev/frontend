import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FoodCache {
  static List<Map<String, dynamic>>? _cachedFoodList;

  static Future<List<Map<String, dynamic>>> loadFoodList(
    BuildContext context,
  ) async {
    if (_cachedFoodList != null) return _cachedFoodList!;
    String jsonString = await rootBundle.loadString(
      'assets/converted_food_data.json',
    );
    List<dynamic> jsonData = json.decode(jsonString);
    _cachedFoodList = List<Map<String, dynamic>>.from(jsonData);
    return _cachedFoodList!;
  }

  // 필요 시 캐시 초기화 (새로고침용)
  static void clearCache() {
    _cachedFoodList = null;
  }
}
