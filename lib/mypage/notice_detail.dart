import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class NoticeDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const NoticeDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '공지 사항'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,)),
            const SizedBox(height: 5),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Text(content, style: const TextStyle(fontSize: 15, height: 1.6,color: Colors.black,)),
          ],
        ),
      ),
    );
  }
}
