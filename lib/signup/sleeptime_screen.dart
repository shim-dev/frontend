import 'package:flutter/material.dart';
import 'caffeine_screen.dart';
import '../DB/signup/DB_sleep.dart';

class SleepTimeScreen extends StatefulWidget {
  final String userId;
  const SleepTimeScreen({super.key, required this.userId});

  @override
  State<SleepTimeScreen> createState() => _SleepTimeScreenState();
}

class _SleepTimeScreenState extends State<SleepTimeScreen> {
  double sleepHours = 8;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('수면 시간', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 6 / 8, // 8단계 중 6단계
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),


      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: basePadding),
        child: Column(
          children: [
            SizedBox(height: deviceHeight * 0.10),
            Image.asset('assets/icon/sleep_turtle.png', height: deviceHeight * 0.18),
            SizedBox(height: deviceHeight * 0.025),
            const Text(
              '평균 수면 시간을 알려주세요!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.012),
            const Text(
              '저속노화의 첫걸음은 충분한 숙면입니다!',
              style: TextStyle(fontSize: 14, color: Color(0xFF545454)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.05),
            const Text(
              '하루 수면 시간은?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
            ),
            SizedBox(height: deviceHeight * 0.025),
            Column(
              children: [
                Text(
                  '${sleepHours.round()} hr',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Slider(
                  value: sleepHours,
                  min: 0,
                  max: 12,
                  divisions: 12,
                  activeColor: const Color(0xFF76AAC6),
                  inactiveColor: Colors.grey[300],
                  onChanged: (value) {
                    setState(() {
                      sleepHours = value;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            // 다음 버튼 (그라데이션)
            SizedBox(
              width: double.infinity,
              height: deviceHeight * 0.06,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await setSleepTime(widget.userId, sleepHours.round());
                    if (result['success']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaffeineIntakeScreen(userId: widget.userId),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'] ?? "오류가 발생했습니다.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('다음', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.03),
            const Column(
              children: [
                Text(
                  'SHIM Lab.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Slow, Heal, Inspire, Mindfulness',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.03),
          ],
        ),
      ),
    );
  }
}
