import 'package:flutter/material.dart';
import 'package:shim/DB/mypage/db_notice.dart';
import 'package:shim/mypage/appbar.dart';

import 'notice_detail.dart';

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
    final data = await fetchNoticesFromDB();
    if (data != null) {
      setState(() {
        notices = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '공지 사항'),
      backgroundColor: Colors.white,
      body:
          notices.isEmpty
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
