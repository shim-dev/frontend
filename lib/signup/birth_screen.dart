import 'package:flutter/material.dart';
import 'gender_screen.dart';
import '../DB/signup/DB_birth.dart';

class BirthScreen extends StatefulWidget {
  final String userId;
  const BirthScreen({super.key, required this.userId});

  @override
  State<BirthScreen> createState() => _BirthScreenState();
}

class _BirthScreenState extends State<BirthScreen> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  final List<String> years =
  List.generate(100, (index) => (DateTime.now().year - index).toString());
  final List<String> months =
  List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> days =
  List.generate(31, (index) => (index + 1).toString().padLeft(2, '0'));

  // 각 드롭다운 포커스 관리 (for 그라데이션)
  final FocusNode _yearFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();

  @override
  void dispose() {
    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;

    // 8단계 중 2단계(진행바)
    const totalSteps = 8;
    final currentStep = 2;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // <- "←" 아이콘
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('생년월일', style: TextStyle(color: Colors.black)),
        centerTitle: true,
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
        padding: EdgeInsets.all(basePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/turtle.png',
                  width: deviceWidth * 0.37,
                  height: deviceWidth * 0.37,
                ),
                SizedBox(width: deviceWidth * 0.04),
                Expanded(
                  child: Text(
                    '안녕하세요! 👋\n저속노화를 위한 맞춤형 서비스를 제공해드리기 위해 간단한 정보를 먼저 입력해 주세요!',
                    style: TextStyle(
                      fontSize: deviceWidth * 0.034,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * 0.04),
            Text(
              '생년(출생년도)을 입력해주세요.',
              style: TextStyle(
                fontSize: deviceWidth * 0.055,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: deviceHeight * 0.035),

            // 드롭다운 3개 (연, 월, 일)
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _GradientDropdown(
                    focusNode: _yearFocus,
                    hint: 'YYYY',
                    value: selectedYear,
                    items: years,
                    onChanged: (val) => setState(() => selectedYear = val),
                  ),
                ),
                SizedBox(width: 8), // 간격 조절
                Expanded(
                  flex: 3,
                  child: _GradientDropdown(
                    focusNode: _monthFocus,
                    hint: 'MM',
                    value: selectedMonth,
                    items: months,
                    onChanged: (val) => setState(() => selectedMonth = val),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: _GradientDropdown(
                    focusNode: _dayFocus,
                    hint: 'DD',
                    value: selectedDay,
                    items: days,
                    onChanged: (val) => setState(() => selectedDay = val),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // 다음 버튼 (모두 선택해야 활성화, 그라데이션)
            SizedBox(
              width: double.infinity,
              height: deviceHeight * 0.06,
              child: (selectedYear != null && selectedMonth != null && selectedDay != null)
                  ? DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  // 다음 버튼 onPressed:
                  onPressed: () async {
                    final birthDate = '$selectedYear-$selectedMonth-$selectedDay';

                    final result = await setBirth(widget.userId, birthDate);

                    if (result['success']) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GenderScreen(userId: widget.userId),
                        ),
                      );
                    } else {
                      // 에러 메시지 띄우기 (예시)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result['message'] ?? '생년월일 저장 실패')),
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
}

/// 드롭다운 밑줄: 포커스 시만 그라데이션, 평소엔 회색
class _GradientDropdown extends StatefulWidget {
  final FocusNode focusNode;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _GradientDropdown({
    required this.focusNode,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  State<_GradientDropdown> createState() => _GradientDropdownState();
}

class _GradientDropdownState extends State<_GradientDropdown> {
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final hasFocus = widget.focusNode.hasFocus;
    return Focus(
      focusNode: widget.focusNode,
      child: SizedBox(
        height: deviceWidth * 0.14, // 높이도 비율로 (약 48~55px)
        child: Stack(
          children: [
            DropdownButtonFormField<String>(
              value: widget.value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              dropdownColor: Colors.white,
              hint: Text(
                widget.hint,
                style: const TextStyle(
                  color: Color(0xFF9F9F9F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              items: widget.items
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: widget.onChanged,
            ),
            // 밑줄(포커스시 그라데이션, 평소엔 연회색)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: hasFocus
                      ? const LinearGradient(
                    colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                  )
                      : const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
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
