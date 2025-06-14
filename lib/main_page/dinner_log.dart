import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shim/DB/db_record.dart';
import 'package:shim/main_page/newsearch_din.dart';

class DinnerLog extends StatefulWidget {
  final Future<void> Function()? onUpdated;
  final Future<void> Function()? onFoodChanged;
  const DinnerLog({Key? key, this.onUpdated, this.onFoodChanged})
    : super(key: key);

  @override
  _DinnerLogState createState() => _DinnerLogState();
}

class _DinnerLogState extends State<DinnerLog> {
  DateTime selectedDate = DateTime.now();

  String get selectedDateKey => DateFormat('yyyy.MM.dd').format(selectedDate);

  Future<List<Map<String, dynamic>>> _loadTodaysFoods() async {
    return await getRecords(selectedDateKey, 'dinner');
  }

  void _goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgPurple = Color(0xFF8F80F9);
    final bgMint = Color(0xFF5ED593);

    return Center(
      child: Container(
        width: 390,
        height: 720,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          shadows: [
            BoxShadow(
              color: bgPurple.withOpacity(0.07),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 상단 바 (뒤로가기 + 제목)
            Positioned(
              left: 0,
              right: 0,
              top: 36,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    // 1. 뒤로가기 버튼 (왼쪽 고정)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icon/arrow_back.svg',
                            width: 24,
                            height: 24,
                            color: bgPurple,
                          ),
                        ),
                      ),
                    ),
                    // 2. 가운데 텍스트 (Row의 중앙에 오도록)
                    Expanded(
                      child: Center(
                        child: Text(
                          '저녁을 기록하세요!',
                          style: TextStyle(
                            color: Color(0xFF1A1D1F),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // 3. 오른쪽은 빈 공간으로 (좌우 대칭)
                    SizedBox(width: 38),
                  ],
                ),
              ),
            ),

            // 날짜 표시 (그라데이션 테두리)
            Positioned(
              left: 32,
              right: 32,
              top: 98,
              child: GradientBorderContainer(
                width: double.infinity,
                height: 54,
                borderRadius: 100,
                borderWidth: 2.1,
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _goToPreviousDay,
                        icon: SvgPicture.asset(
                          'assets/icon/left_arrow.svg',
                          width: 16,
                          height: 16,
                          color: bgPurple,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Text(
                          selectedDateKey,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                            letterSpacing: 1.0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _goToNextDay,
                        icon: SvgPicture.asset(
                          'assets/icon/right_arrow.svg',
                          width: 16,
                          height: 16,
                          color: bgPurple,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 음식 목록
            Positioned(
              left: 18,
              right: 18,
              top: 178,
              bottom: 100,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _loadTodaysFoods(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final todaysFoods = snapshot.data!;
                  if (todaysFoods.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [
                                  Color(0xFF8F80F9).withOpacity(0.32),
                                  Color(0xFF5ED593).withOpacity(0.32),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcIn,
                            child: SvgPicture.asset(
                              'assets/icon/fish.svg',
                              width: 95,
                              height: 95,
                            ),
                          ),
                          SizedBox(height: 14),
                          Text(
                            '기록을 잊으셨나요?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: todaysFoods.length,
                    padding: EdgeInsets.only(top: 12, bottom: 20),
                    itemBuilder: (context, index) {
                      final food = todaysFoods[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              bgPurple.withOpacity(0.09),
                              bgMint.withOpacity(0.09),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ✅ 텍스트가 줄바꿈 가능하게 확장됨
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food['name'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Pretendard',
                                      decoration: TextDecoration.none,
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${food['kcal']} Kcal',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    await _editFood(context, food);
                                    if (widget.onUpdated != null) {
                                      await widget.onUpdated!();
                                    }
                                    if (widget.onFoodChanged != null) {
                                      await widget.onFoodChanged!();
                                    }
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: bgPurple,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text(
                                    '수정',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await deleteRecord(food['_id']);
                                    if (widget.onUpdated != null) {
                                      await widget.onUpdated!();
                                    }
                                    if (widget.onFoodChanged != null) {
                                      await widget.onFoodChanged!();
                                    }
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // 추가 버튼 (브랜드 스타일, 그림자/그라데이션)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SearchAddScreenDin(
                              selectedDate: selectedDate,
                              mealType: 'dinner',
                              onUpdated: widget.onUpdated,
                            ),
                      ),
                    );
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [bgPurple, bgMint],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: bgPurple.withOpacity(0.16),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 38),
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

  Future<void> _editFood(
    BuildContext context,
    Map<String, dynamic> food,
  ) async {
    final nameController = TextEditingController(text: food['name']);
    final totalGController = TextEditingController(
      text: food['total_g'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('음식 수정하기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '음식명'),
              ),
              TextField(
                controller: totalGController,
                decoration: const InputDecoration(labelText: '총 중량 (g), (ml)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 기존, 수정된 total_g
                final oldTotalG =
                    (food['total_g'] as num?)?.toDouble() ?? 100.0;
                final newTotalG =
                    double.tryParse(totalGController.text) ?? oldTotalG;
                final ratio = newTotalG / oldTotalG;

                // 자동으로 맞춰줄 필드(7개만)
                final fieldsToScale = [
                  'carbohydrate_g',
                  'fat_g',
                  'kcal',
                  'protein_g',
                  'saturated_fat_g',
                  'sodium_mg',
                  'sugars_g',
                ];

                // 수정 데이터
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'total_g': newTotalG,
                };

                // 나머지 성분도 비율 맞춰 수정
                for (final field in fieldsToScale) {
                  if (food.containsKey(field) && food[field] != null) {
                    final oldValue = (food[field] as num).toDouble();
                    updatedData[field] = double.parse(
                      (oldValue * ratio).toStringAsFixed(2),
                    );
                  }
                }

                await updateRecord(food['_id'], updatedData);

                if (widget.onFoodChanged != null) {
                  await widget.onFoodChanged!();
                }
                if (widget.onUpdated != null) {
                  await widget.onUpdated!();
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }
}

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;

  const GradientBorderContainer({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.borderRadius = 100,
    this.borderWidth = 2.2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderRadius: borderRadius,
        borderWidth: borderWidth,
      ),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final gradient = LinearGradient(
      colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
