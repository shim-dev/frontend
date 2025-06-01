import 'package:flutter/material.dart';
import 'notice_detail.dart';
import 'package:capstone_trial_01/appbar.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '공지 사항'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildNoticeItem(
            context: context,
            screenWidth: screenWidth,
            title: '한번 더 편리해진 2.0 업데이트 안내',
            date: '2025-05-01',
            content: '2.0 업데이트로 더욱 편리한 기능이 추가되었습니다!',
          ),
          _buildNoticeItem(
            context: context,
            screenWidth: screenWidth,
            title: '레시피 업데이트 안내',
            date: '2025-05-01',
            content: '레시피가 새롭게 보강되어 더 다양한 식단을 제공합니다.',
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({
  required BuildContext context,
  required double screenWidth,
  required String title,
  required String date,
  required String content,}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoticeDetailPage(title: title, content: content, date: date),
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
                // 텍스트들
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
                      const SizedBox(height: 6), // 제목과 날짜 사이 간격
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
