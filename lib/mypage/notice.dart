import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'notice_detail.dart';
import 'package:capstone_trial_01/appbar.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({super.key});

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<dynamic> notices = [];

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/mypage/notice');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          notices = json.decode(response.body);
        });
      } else {
        print('❌ 공지사항 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '공지 사항'),
      backgroundColor: Colors.white,
      body: notices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return _buildNoticeItem(
                  context: context,
                  screenWidth: screenWidth,
                  title: notice['title'],
                  date: notice['date'],
                  noticeId: notice['id'],
                );
              },
            ),
    );
  }

  Widget _buildNoticeItem({
    required BuildContext context,
    required double screenWidth,
    required String title,
    required String date,
    required String noticeId,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoticeDetailPage(noticeId: noticeId),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.035,
              horizontal: screenWidth * 0.05,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
        const Divider(thickness: 0.8, color: Colors.black12),
      ],
    );
  }
}
