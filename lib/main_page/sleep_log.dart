import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SleepLogDialog extends StatefulWidget {
  final double initialHours;
  final ValueChanged<double> onSaved;

  const SleepLogDialog({
    Key? key,
    required this.initialHours,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<SleepLogDialog> createState() => _SleepLogDialogState();
}

class _SleepLogDialogState extends State<SleepLogDialog> {
  late double sleepHours;

  @override
  void initState() {
    super.initState();
    sleepHours = widget.initialHours;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 내용만큼만
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: SvgPicture.asset(
                'assets/icon/zzz.svg',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Text(
              "잠은 잘 자고 있나요?",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),

      content: SizedBox(
        width: 280,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 게이지
            Positioned(
              top: 18,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 108,
                child: SleepGauge(
                  value: sleepHours,
                  max: 12,
                  onChanged: (v) {
                    setState(() {
                      sleepHours = v;
                    });
                  },
                ),
              ),
            ),
            // 시간 텍스트
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    TextEditingController controller = TextEditingController(
                      text: sleepHours.toStringAsFixed(1),
                    );
                    double? newValue = await showDialog<double>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("수면 시간 직접 입력"),
                            content: TextField(
                              controller: controller,
                              autofocus: true,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: "몇 시간 잤나요? (0 ~ 12)",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("취소"),
                              ),
                              TextButton(
                                onPressed: () {
                                  double? v = double.tryParse(controller.text);
                                  if (v != null && v >= 0 && v <= 12) {
                                    Navigator.pop(context, v);
                                  }
                                },
                                child: Text("확인"),
                              ),
                            ],
                          ),
                    );
                    if (newValue != null) {
                      setState(() {
                        sleepHours = newValue;
                      });
                    }
                  },
                  child: Text(
                    "${sleepHours.toStringAsFixed(1)} 시간",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF8F80F9),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("취소", style: TextStyle(color: Color(0xFF8F80F9))),
        ),
        // 그라데이션 저장 버튼
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            onPressed: () {
              widget.onSaved(sleepHours);
              Navigator.pop(context, sleepHours);
            },
            child: Text("저장", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

// SleepGauge: 게이지만 수정 (그라데이션 반원)
class SleepGauge extends StatelessWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  const SleepGauge({
    Key? key,
    required this.value,
    required this.max,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) => _onPanUpdate(details, constraints),
          onTapDown:
              (details) => _onPanUpdate(
                DragUpdateDetails(
                  localPosition: details.localPosition,
                  globalPosition: details.globalPosition,
                  delta: Offset.zero,
                ),
                constraints,
              ),
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _GradientGaugePainter(value, max),
            child: Container(),
          ),
        );
      },
    );
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final size = constraints.biggest;
    final center = Offset(size.width / 2, size.height);
    final touch = details.localPosition;
    final dx = touch.dx - center.dx;
    final dy = touch.dy - center.dy;
    double theta = atan2(dy, dx);
    if (theta < -pi) theta += 2 * pi;
    if (theta > 0 || theta < -pi) return;
    final percent = 1 - (theta.abs() / pi);
    double v = max * percent;
    if (v < 0) v = 0;
    if (v > max) v = max;
    onChanged(double.parse(v.toStringAsFixed(1)));
  }
}

class _GradientGaugePainter extends CustomPainter {
  final double value;
  final double max;

  _GradientGaugePainter(this.value, this.max);

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 18.0;
    final double arcPadding = strokeWidth / 2 + 8;
    final Rect arcRect = Rect.fromLTWH(
      arcPadding,
      arcPadding,
      size.width - arcPadding * 2,
      size.height * 2 - arcPadding * 2,
    );

    // (1) 배경: 아주 연한 색 (mint쪽)
    final Paint base =
        Paint()
          ..color = Color(0xFFE0F2E8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, pi, pi, false, base);

    // (2) 게이지: 그라데이션(보라 → 민트)
    if (value > 0) {
      final sweep = (value / max) * pi;
      final Gradient gradient = LinearGradient(
        colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      final Rect shaderRect = arcRect;
      final Paint progress =
          Paint()
            ..shader = gradient.createShader(shaderRect)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round;
      canvas.drawArc(arcRect, pi, sweep, false, progress);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
