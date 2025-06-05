import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shim/DB/mypage/db_event.dart';
import 'package:shim/mypage/appbar.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  String title = '';
  String content = '';
  String date = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEventDetail();
  }

  void fetchEventDetail() async {
    final data = await fetchEventDetailFromDB(widget.eventId);
    if (data != null) {
      setState(() {
        title = data['title'];
        content = data['content'] ?? '';
        date = data['date'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(title: '이벤트'),
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      /// 제목
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      /// 날짜
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      /// 본문 (HTML 렌더링)
                      Html(
                        data: content,
                        style: {
                          "body": Style(
                            fontSize: FontSize(15),
                            lineHeight: LineHeight.number(1.6),
                            color: Colors.black,
                          ),
                        },
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      /// 참여 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // 참여하기 동작 정의
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
