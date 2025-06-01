import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'activity_screen.dart';

class HeightWeightScreen extends StatefulWidget {
  const HeightWeightScreen({super.key});

  @override
  State<HeightWeightScreen> createState() => _HeightWeightScreenState();
}

class _HeightWeightScreenState extends State<HeightWeightScreen> {
  int selectedHeight = 160;
  int selectedWeight = 50;

  final List<int> heights = List.generate(121, (index) => 140 + index); // 140~260
  final List<int> weights = List.generate(121, (index) => 30 + index); // 30~150

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 8단계 중 4단계
    const totalSteps = 8;
    final currentStep = 4;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ← 변경
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('키/몸무게', style: TextStyle(color: Colors.black)),
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
            SizedBox(height: deviceHeight * 0.04),
            Image.asset(
              'assets/icon/turtle.png',
              width: deviceWidth * 0.38,
              height: deviceWidth * 0.38,
            ),
            SizedBox(height: deviceHeight * 0.03),
            Text(
              '키와 몸무게를 알려주세요.',
              style: TextStyle(
                fontSize: deviceWidth * 0.055,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.015),
            Text(
              '몸무게와 키를 알려주시면,\n당신에게 맞는 저속노화 식단 평가를\n더 정확하게 도와드릴 수 있어요! 🥗✨',
              style: TextStyle(fontSize: deviceWidth * 0.037, color: const Color(0xFF545454)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.038),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('키', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                    SizedBox(
                      height: deviceHeight * 0.23,
                      width: deviceWidth * 0.25,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: heights.indexOf(selectedHeight),
                        ),
                        itemExtent: deviceHeight * 0.045,
                        useMagnifier: true,
                        magnification: 1.18,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedHeight = heights[index];
                          });
                        },
                        children: heights
                            .map((h) => Center(
                          child: Text(
                            '$h',
                            style: TextStyle(fontSize: deviceWidth * 0.052, color: Colors.black),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    const Text('cm'),
                  ],
                ),
                Column(
                  children: [
                    const Text('몸무게', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                    SizedBox(
                      height: deviceHeight * 0.23,
                      width: deviceWidth * 0.25,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: weights.indexOf(selectedWeight),
                        ),
                        itemExtent: deviceHeight * 0.045,
                        useMagnifier: true,
                        magnification: 1.18,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedWeight = weights[index];
                          });
                        },
                        children: weights
                            .map((w) => Center(
                          child: Text(
                            '$w',
                            style: TextStyle(fontSize: deviceWidth * 0.052, color: Colors.black),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                    const Text('kg'),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // 다음 버튼 (항상 활성, 그라데이션)
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
                    print('선택된 키: $selectedHeight');
                    print('선택된 몸무게: $selectedWeight');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActivityLevelScreen(),
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
