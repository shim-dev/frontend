import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class EventDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const EventDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(title: '이벤트'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              /// 제목
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color : Colors.black),
              ),

              /// 날짜
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),

              /// 이미지
              SizedBox(height: screenHeight * 0.025),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/launching_event.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              /// 본문
              Text(
                content,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black),
              ),

              SizedBox(height: screenHeight * 0.03),

              /// 참여 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 참여하기 버튼 동작 정의
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37966F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '참여하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
