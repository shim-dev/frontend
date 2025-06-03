import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shim/DB/DB_helper.dart';

// ✅ 기록 추가 (Insert)
Future<void> insertRecord(Map<String, dynamic> data) async {
  final userId = await getUserId();
  print('[DEBUG] insertRecord - user_id: $userId');
  final mergedData = {...data, 'user_id': userId};
  final response = await http.post(
    Uri.parse('$apiBase/insert_record'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(mergedData),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to insert record');
  }
}

// ✅ 기록 불러오기 (날짜 + 식사타입)
Future<List<Map<String, dynamic>>> getRecords(
  String date,
  String mealType,
) async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse(
      '$apiBase/get_records?user_id=$userId&date=$date&mealType=$mealType',
    ),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Map<String, dynamic>>((e) {
      if (e['_id'] is Map && e['_id']['\$oid'] != null) {
        e['_id'] = e['_id']['\$oid'];
      }
      return Map<String, dynamic>.from(e);
    }).toList();
  } else {
    throw Exception('Failed to get records');
  }
}

// ✅ 기록 삭제
Future<void> deleteRecord(String id) async {
  final userId = await getUserId();
  final response = await http.delete(
    Uri.parse('$apiBase/delete_record?id=$id&user_id=$userId'),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to delete record');
  }
}

// ✅ 기록 업데이트
Future<void> updateRecord(String id, Map<String, dynamic> data) async {
  final userId = await getUserId();
  data['_id'] = id;
  data['user_id'] = userId;
  final response = await http.put(
    Uri.parse('$apiBase/update_record'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to update record');
  }
}

// ✅ 오늘 날짜의 특정 식사 기록
Future<List<Map<String, dynamic>>> getRecords1(String mealType) async {
  String date = todayStr();
  return getRecords(date, mealType);
}

// ✅ 특정 날짜의 특정 식사 기록
Future<List<Map<String, dynamic>>> getRecordsByDate(
  String mealType,
  String date,
) async {
  return getRecords(date, mealType);
}

// ✅ 오늘 물컵 기록 저장
Future<void> saveWaterCups(int cups) async {
  final userId = await getUserId();
  final response = await http.post(
    Uri.parse('$apiBase/save_water'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'date': todayStr(), 'cups': cups}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to save water cups');
  }
}

// ✅ 특정 날짜의 물컵 기록 불러오기
Future<int> getWaterCups(String date) async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_water?user_id=$userId&date=$date'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['cups'] as int?) ?? 0;
  }
  return 0;
}

// ✅ 오늘 물컵 불러오기
Future<int> getTodayCups() async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_water?user_id=$userId&date=${todayStr()}'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['cups'] ?? 0;
  }
  return 0;
}

// ✅ 수면 기록 저장/수정
Future<void> insertOrUpdateSleep(double hours, String date) async {
  final userId = await getUserId();
  final response = await http.post(
    Uri.parse('$apiBase/insert_or_update_sleep'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'date': date, 'hours': hours}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to insert/update sleep');
  }
}

// ✅ 수면 기록 불러오기
Future<double> getSleep(String date) async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_sleep?user_id=$userId&date=$date'),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['hours'] as num?)?.toDouble() ?? 0.0;
  }
  return 0.0;
}

// ✅ 모든 기록 가져오기 (유저별)
Future<List<Map<String, dynamic>>> getAllRecords() async {
  final userId = await getUserId();
  final response = await http.get(
    Uri.parse('$apiBase/get_all_records?user_id=$userId'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map<Map<String, dynamic>>((e) {
      if (e['_id'] is Map && e['_id']['\$oid'] != null) {
        e['_id'] = e['_id']['\$oid'];
      }
      return Map<String, dynamic>.from(e);
    }).toList();
  } else {
    throw Exception('Failed to get all records');
  }
}
