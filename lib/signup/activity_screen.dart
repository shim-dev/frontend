import 'package:flutter/material.dart';
import 'sleeptime_screen.dart';
import '../DB/signup/DB_activity.dart';

class ActivityLevelScreen extends StatefulWidget {
  final String userId;
  const ActivityLevelScreen({super.key, required this.userId});

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  int? selectedIndex = 0;

  final List<String> activityLevels = [
    '주 1회 이하',
    '주 1 - 2회',
    '주 3 - 4회',
    '주 5 - 6회',
    '주 7회 이상',
  ];

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 진행바: 8단계 중 5단계
    const totalSteps = 8;
    final currentStep = 5;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // ←로 변경
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('활동량', style: TextStyle(color: Colors.black)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: basePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: deviceHeight * 0.04),
              Image.asset(
                'assets/icon/active_turtle.png',
                width: deviceWidth * 0.53,
                height: deviceWidth * 0.53,
              ),
              SizedBox(height: deviceHeight * 0.025),
              Text(
                '평소 활동량을 알려주세요.',
                style: TextStyle(
                  fontSize: deviceWidth * 0.054,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: deviceHeight * 0.012),
              Text(
                '활동량에 따른 올바른 맞춤 정보를\n제공해드릴게요! 💡🧬',
                style: TextStyle(fontSize: deviceWidth * 0.038, color: const Color(0xFF545454)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: deviceHeight * 0.03),

              // 라디오 버튼 리스트
              ...List.generate(activityLevels.length, (index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.008),
                    child: Row(
                      children: [
                        _RadioGradientDot(selected: selectedIndex == index),
                        SizedBox(width: deviceWidth * 0.03),
                        Expanded(
                          child: Text(
                            activityLevels[index],
                            style: TextStyle(
                              fontSize: deviceWidth * 0.043,
                              color: Colors.black,
                              fontWeight: selectedIndex == index ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: deviceHeight * 0.05),
              // 다음 버튼
              SizedBox(
                width: double.infinity,
                height: deviceHeight * 0.06,
                child: selectedIndex != null
                    ? DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (selectedIndex != null) {
                        final activity = activityLevels[selectedIndex!];
                        final result = await setActivityLevel(widget.userId, activity);
                        if (result['success']) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SleepTimeScreen(userId: widget.userId),
                            ),
                          );
                        } else {
                          // 오류 처리
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'] ?? "오류가 발생했습니다.")),
                          );
                        }
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
      ),
    );
  }
}

///  라디오 체크
class _RadioGradientDot extends StatelessWidget {
  final bool selected;
  const _RadioGradientDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF8F80F9) : Colors.grey,
          width: 2,
        ),
      ),
      child: selected
          ? Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
          ),
        ),
      )
          : null,
    );
  }
}
