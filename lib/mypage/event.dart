import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'event_detail.dart';
import 'package:capstone_trial_01/appbar.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/mypage/event');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          events = json.decode(response.body);
        });
      } else {
        print('❌ 이벤트 목록 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '이벤트'),
      backgroundColor: Colors.white,
      body: events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventItem(
                  context: context,
                  screenWidth: screenWidth,
                  iconPath: 'assets/icon/celebration.svg',
                  title: event['title'],
                  date: event['date'],
                  eventId: event['id'], // 👈 중요: id 넘기기
                );
              },
            ),
    );
  }

  Widget _buildEventItem({
    required BuildContext context,
    required double screenWidth,
    required String iconPath,
    required String title,
    required String date,
    required String eventId,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailPage(eventId: eventId),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03,
              horizontal: screenWidth * 0.05,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF69B294),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: screenWidth * 0.05,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.chevron_right, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black12, thickness: 1),
      ],
    );
  }
}
