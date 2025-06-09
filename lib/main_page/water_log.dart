import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaterIntakeDialog extends StatefulWidget {
  final int initialCups;
  final ValueChanged<int> onSaved;

  const WaterIntakeDialog({
    Key? key,
    required this.initialCups,
    required this.onSaved,
  }) : super(key: key);

  @override
  State<WaterIntakeDialog> createState() => _WaterIntakeDialogState();
}

class _WaterIntakeDialogState extends State<WaterIntakeDialog> {
  late int selectedCups;

  @override
  void initState() {
    super.initState();
    selectedCups = widget.initialCups;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(Icons.water_drop, color: Colors.white), // 아이콘 하얀색!
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              "수분을 어느 정도 섭취했나요?",
              style: TextStyle(
                color: Colors.black, // ← 검정색!
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 280,
        height: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              itemCount: 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                bool filled = index < selectedCups;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCups == 1 && index == 0) {
                        selectedCups = 0; // 다시 눌렀을 때 0잔
                      } else {
                        selectedCups = index + 1;
                      }
                    });
                  },
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [Color(0x885ED593), Color(0x668F80F9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: SvgPicture.asset(
                      filled
                          ? 'assets/icon/water_interaction_02.svg'
                          : 'assets/icon/water_interaction_01.svg',
                      width: 40,
                      height: 40,
                      color: Colors.white, // SVG가 흰색이어야 그라데이션이 입혀져요!
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("취소", style: TextStyle(color: Color(0xFF8F80F9))),
        ),
        // 그라데이션 버튼
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
            onPressed: () async {
              widget.onSaved(selectedCups);
              Navigator.pop(context, selectedCups);
            },
            child: Text("저장", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
