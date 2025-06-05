import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shim/DB/signup/DB_alcohol.dart';
import 'package:shim/signup/signup_complete_screen.dart';

class AlcoholIntakeScreen extends StatefulWidget {
  final String userId;
  const AlcoholIntakeScreen({super.key, required this.userId});

  @override
  State<AlcoholIntakeScreen> createState() => _AlcoholIntakeScreenState();
}

class _AlcoholIntakeScreenState extends State<AlcoholIntakeScreen> {
  int selectedCups = 0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 8단계 중 8단계(진행바)
    const totalSteps = 8;
    final currentStep = 8;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ←
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('음주량', style: TextStyle(color: Colors.black)),
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
                  widthFactor: progressValue,
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
            SizedBox(height: deviceHeight * 0.13),
            const Text(
              '술 섭취량을 점검해볼까요?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '괜찮아요. 쉼;(SHIM)과 함께라면 절주도 가능!',
              style: TextStyle(fontSize: 14, color: Color(0xFF545454)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.025),
            Image.asset(
              'assets/icon/drunk_turtle.png',
              width: deviceWidth * 0.48,
              height: deviceWidth * 0.48,
            ),
            SizedBox(height: deviceHeight * 0.025),
            const Text(
              '평균 섭취량은?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),

            // 클릭 가능한 잔 아이콘
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: List.generate(8, (index) {
                bool filled = index < selectedCups;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // 같은 잔수 누르면 0잔으로(토글)
                      if (selectedCups == index + 1) {
                        selectedCups = 0;
                      } else {
                        selectedCups = index + 1;
                      }
                    });
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors:
                            filled
                                ? [Color(0xFF8F80F9), Color(0xFF5ED593)]
                                : [Colors.grey.shade300, Colors.grey.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: SvgPicture.asset(
                      filled
                          ? 'assets/icon/water_interaction_02.svg'
                          : 'assets/icon/water_interaction_01.svg',
                      width: deviceWidth * 0.15,
                      height: deviceWidth * 0.15,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),
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
                    final result = await setAlcohol(
                      widget.userId,
                      selectedCups,
                    ); // 함수명, 파라미터명 변경
                    if (result['success']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupCompleteScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result['message'] ?? "오류가 발생했습니다."),
                        ),
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
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
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
