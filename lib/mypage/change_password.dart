import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final Color green = const Color(0xFF37966F);
  final Color hoverGreen = const Color(0xFF76D9A8);

  String newPassword = '';
  String confirmPassword = '';
  String? confirmError;

  bool get isLengthValid => newPassword.length >= 10 && newPassword.length <= 16;

  bool get isCharMixValid =>
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(newPassword);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '비밀번호 변경'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('현재 비밀번호', style: TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: const TextStyle(
                fontSize: 16,             // 크기 조정
                letterSpacing: 2.5,       // 점 간 간격 넓힘 (선택)
                color:  Color(0xFF666666),      // 점 색상
              ),
              decoration: InputDecoration(
                hintText: '현재 비밀번호를 입력해 주세요.',
                hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 24),
            const Text('신규 비밀번호', style: TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: const TextStyle(
                fontSize: 16,             // 크기 조정
                letterSpacing: 2.5,       // 점 간 간격 넓힘 (선택)
                color:  Color(0xFF666666),      // 점 색상
              ),
              onChanged: (val) => setState(() => newPassword = val),
              decoration: InputDecoration(
                hintText: '신규 비밀번호를 입력해 주세요.',
                hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 12),
            _buildStrengthBar(passwordStrength),

            const SizedBox(height: 12),
            // 조건 1: 길이 체크
          Row(
            children: [
              Icon(
                Icons.check,
                color: isLengthValid ? Color(0xFF37966F) : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '10자 이상 ~ 16자 이내 입력',
                style: TextStyle(
                  color: isLengthValid ? Color(0xFF37966F) : Color(0xFF666666),
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // 조건 2: 문자 조합 체크
          Row(
            children: [
              Icon(
                Icons.check,
                color: isCharMixValid ? Color(0xFF37966F) : Colors.grey,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                '영문 대문자, 소문자, 숫자 혼합 (특수문자 불가)',
                style: TextStyle(
                  color: isCharMixValid ? Color(0xFF37966F) : Color(0xFF666666),
                  fontSize: 15,
                ),
              ),
            ],
          ),

            const SizedBox(height: 24),
            const Text('비밀번호 확인', style: TextStyle(color: Colors.black, fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              style: const TextStyle(
                fontSize: 16,             // 크기 조정
                letterSpacing: 2.5,       // 점 간 간격 넓힘 (선택)
                color:  Color(0xFF666666),      // 점 색상
              ),
              onChanged: (val) {
              setState(() {
                confirmPassword = val;
                confirmError = (confirmPassword != newPassword)
                    ? '비밀번호가 일치하지 않습니다.'
                    : null;
              });
            },
              decoration: InputDecoration(
                hintText: '비밀번호를 확인해 주세요.',
                hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: confirmError != null ? Colors.red : green,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          if (confirmError != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 6),
              child: Text(
                confirmError!,
                style: const TextStyle(
                  fontSize: 14, 
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: green),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('취소', style: TextStyle(color: Color(0xFF37966F))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (confirmPassword != newPassword) {
                        setState(() {
                          confirmError = '비밀번호가 일치하지 않습니다.';
                        });
                      } else {
                        setState(() {
                          confirmError = null;
                        });
                        // TODO: 실제 변경 로직 실행
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => states.contains(MaterialState.hovered) ? hoverGreen : green,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(const Size.fromHeight(52)),
                    ),
                    child: const Text('변경', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

int get passwordStrength {
  if (isLengthValid && isCharMixValid) return 3; // 안전
  if (isLengthValid || isCharMixValid) return 2; // 보통
  return 1; // 위험
}

Widget _buildStrengthBar(int level) {
  Color color;
  switch (level) {
    case 1:
      color = Colors.red;
      break;
    case 2:
      color = Colors.orange;
      break;
    case 3:
      color = Color(0xFF37966F); // 초록
      break;
    default:
      color = Colors.grey;
  }

  return Row(
    children: List.generate(3, (index) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          decoration: BoxDecoration(
            color: index < level ? color : Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      );
    }),
  );
}

}