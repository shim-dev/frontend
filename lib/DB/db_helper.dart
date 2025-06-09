import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiBase = 'http://210.125.91.93:5000';

final FlutterSecureStorage _storage = FlutterSecureStorage();

String todayStr() {
  final now = DateTime.now();
  return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
}

Future<String> getUserId() async {
  String? userId = await _storage.read(key: 'user_id');
  if (userId == null) throw Exception('로그인 정보 없음!');
  return userId;
}
