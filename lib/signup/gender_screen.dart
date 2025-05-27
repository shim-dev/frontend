import 'package:flutter/material.dart';
import 'height_weight_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? selectedGender;

  void selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 진행바: 8단계 중 3단계
    const totalSteps = 8;
    final currentStep = 3;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ←로 변경!
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('성별', style: TextStyle(color: Colors.black)),
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
              '성별을 알려주세요.',
              style: TextStyle(
                fontSize: deviceWidth * 0.07,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.016),
            Text(
              '성별을 선택해주시면, 더 맞춤화된 노화 분석 결과를 제공해드릴 수 있어요! 💡🧬',
              style: TextStyle(fontSize: deviceWidth * 0.037, color: const Color(0xFF545454)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderOption('female', 'assets/icon/female_turtle.png', deviceWidth),
                _buildGenderOption('male', 'assets/icon/male_turtle.png', deviceWidth),
                _buildGenderOption('none', 'assets/icon/none_turtle.png', deviceWidth),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: deviceHeight * 0.06,
              child: selectedGender != null
                  ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print('선택된 성별: $selectedGender');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HeightWeightScreen(),
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
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
                  : ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildGenderOption(String gender, String assetPath, double deviceWidth) {
    final isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () => selectGender(gender),
      child: Container(
        width: deviceWidth * 0.26,
        height: deviceWidth * 0.26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
            width: 3,
            // 그라데이션 border를 직접 지원 안 하므로, 아래처럼 gradient + ShaderMask 사용:
            color: Colors.transparent,
          )
              : Border.all(color: Colors.transparent),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipOval(
              child: Image.asset(assetPath, fit: BoxFit.cover),
            ),
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.transparent, width: 3),
                    // 아래 ShaderMask로 외곽선 그라데이션 효과
                  ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0), // 내부 border 투명
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
