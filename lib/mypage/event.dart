import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:capstone_trial_01/appbar.dart';
import 'event_detail.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '이벤트'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildEventItem(
            context: context,
            screenWidth: screenWidth,
            iconPath: 'assets/icon/celebration.svg',
            title: '런칭 이벤트 ( ~30일)',
            subtitle: '런칭을 맞아 1달간 모든 서비스 무료 제공!',
            date: '2025-05-01',
          ),
          _buildEventItem(
            context: context,
            screenWidth: screenWidth,
            iconPath: 'assets/icon/celebration.svg',
            title: '런칭 이벤트 ( ~30일)',
            subtitle: '런칭을 맞아 1달간 모든 서비스 무료 제공!',
            date: '2025-05-01',
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required BuildContext context,
    required double screenWidth,
    required String iconPath,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(
                  title: title,
                  content:'''
안녕하세요!

새로운 서비스 런칭을 기념하여 특별 이벤트를 준비했습니다. 이벤트 기간 동안 모든 서비스를 무료로 이용하실 수 있습니다.

이벤트 기간: 2025년 5월 1일 ~ 2025년 5월 30일

참여 방법:

1. 앱을 다운로드하고 회원가입을 완료해주세요.
2. 이벤트 기간 내에 서비스를 자유롭게 이용해보세요.
3. 추가 혜택: 친구에게 추천하면 추가 혜택을 드립니다!

많은 관심과 참여 부탁드립니다.

감사합니다.
''',

                  date: date,
                ),
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
                      SizedBox(height: screenWidth * 0.001),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.01),
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
