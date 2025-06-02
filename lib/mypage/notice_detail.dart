import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_trial_01/appbar.dart';

class NoticeDetailPage extends StatefulWidget {
  final String noticeId;

  const NoticeDetailPage({super.key, required this.noticeId});

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  Map<String, dynamic>? notice;

  @override
  void initState() {
    super.initState();
    fetchNoticeDetail();
  }

  Future<void> fetchNoticeDetail() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/mypage/notice/${widget.noticeId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          notice = json.decode(response.body);
        });
      } else {
        print('❌ 공지 상세 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '공지 사항'),
      backgroundColor: Colors.white,
      body: notice == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Text(
                    notice!['title'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notice!['date'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    notice!['content'],
                    style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black),
                  ),
                ],
              ),
            ),
    );
  }
}
