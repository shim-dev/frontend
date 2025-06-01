import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'alcohol_screen.dart';

class CaffeineIntakeScreen extends StatefulWidget {
  const CaffeineIntakeScreen({super.key});

  @override
  State<CaffeineIntakeScreen> createState() => _CaffeineIntakeScreenState();
}

class _CaffeineIntakeScreenState extends State<CaffeineIntakeScreen> {
  int selectedCups = 0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 8단계 중 7단계(진행바)
    const totalSteps = 8;
    final currentStep = 7;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('커피 섭취량', style: TextStyle(color: Colors.black)),
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
            SizedBox(height: deviceHeight * 0.12),
            Text(
              '카페인 섭취량을 점검해볼까요?',
              style: TextStyle(
                fontSize: deviceWidth * 0.057,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.012),
            Text(
              '커피를 비롯한 카페인 음료 섭취량을\n솔직하게 적어주세요.',
              style: TextStyle(
                fontSize: deviceWidth * 0.037,
                color: const Color(0xFF545454),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.03),
            Image.asset(
              'assets/icon/coffee_turtle.png',
              width: deviceWidth * 0.5,
              height: deviceWidth * 0.5,
            ),
            SizedBox(height: deviceHeight * 0.02),
            Text(
              '하루 커피 섭취량은?',
              style: TextStyle(
                fontSize: deviceWidth * 0.058,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: deviceHeight * 0.01),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: List.generate(8, (index) {
                bool filled = index < selectedCups;
                return GestureDetector(
                  onTap: () {
                    setState(() {
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
                        colors: filled
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
                  onPressed: () {
                    print('선택된 컵 수: $selectedCups');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AlcoholIntakeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
