import 'package:flutter/material.dart';
import 'package:shim/mypage/appbar.dart';
import 'package:shim/DB/mypage/db_mypage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final Color green = const Color(0xFF37966F);
  final Color hoverGreen = const Color(0xFF76D9A8);

  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  String? confirmError;
  String? currentPasswordError; 

  bool get isLengthValid {
    final newPw = newController.text.trim();
    return newPw.length >= 10 && newPw.length <= 16;
  }

  bool get isCharMixValid {
    final newPw = newController.text.trim();
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{10,16}$').hasMatch(newPw);
  }

  bool get isPasswordMatch =>
      confirmController.text.trim() == newController.text.trim();

  int get passwordStrength {
    if (isLengthValid && isCharMixValid) return 3;
    if (isLengthValid || isCharMixValid) return 2;
    return 1;
  }

  Future<void> handleChangePassword() async {
    final currentPw = currentController.text.trim();
    final newPw = newController.text.trim();
    final confirmPw = confirmController.text.trim();

    if (newPw != confirmPw) {
      setState(() => confirmError = '비밀번호가 일치하지 않습니다.');
      return;
    }

    setState(() => confirmError = null);

    try {
      final success = await changePassword(currentPw, newPw);
      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
        );
      }
    } catch (e) {
      final errorMsg = e.toString().replaceFirst("Exception: ", "");

      setState(() {
        // 현재 비밀번호 틀림 메시지라면 input 아래에 보여주기
        if (errorMsg.contains('현재 비밀번호')) {
          currentPasswordError = errorMsg;
        } else {
          currentPasswordError = null;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final isAllValid = isLengthValid && isCharMixValid && isPasswordMatch;

    return Scaffold(
      appBar: const CustomAppBar(title: '비밀번호 변경'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text('현재 비밀번호', style: TextStyle(fontSize: 18, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: currentController,
              obscureText: true,
              onChanged: (_) => setState(() {
                currentPasswordError = null; // 다시 입력 시 에러 지움
              }),
              style: const TextStyle(fontSize: 16, letterSpacing: 2.5),
              decoration: _inputDecoration('현재 비밀번호를 입력해 주세요.'),
            ),
            if (currentPasswordError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 6),
                child: Text(
                  currentPasswordError!,
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),

            const Text('신규 비밀번호', style: TextStyle(fontSize: 18,color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: newController,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 16, letterSpacing: 2.5),
              decoration: _inputDecoration('신규 비밀번호를 입력해 주세요.'),
            ),
            const SizedBox(height: 12),
            _buildStrengthBar(passwordStrength),
            const SizedBox(height: 12),
            _checkRow('10자 이상 ~ 16자 이내 입력', isLengthValid),
            const SizedBox(height: 4),
            _checkRow('영문 대문자, 소문자, 숫자 혼합', isCharMixValid),

            const SizedBox(height: 24),
            const Text('비밀번호 확인', style: TextStyle(fontSize: 18,color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: confirmController,
              obscureText: true,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 16, letterSpacing: 2.5),
              decoration: _inputDecoration('비밀번호를 확인해 주세요.').copyWith(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: confirmError != null ? Colors.red : green,
                      width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (confirmError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 6),
                child: Text(confirmError!,
                    style: const TextStyle(fontSize: 14, color: Colors.red)),
              ),
            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('취소',
                        style: TextStyle(color: Color(0xFF37966F))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAllValid ? handleChangePassword : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      minimumSize: const Size.fromHeight(52),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _checkRow(String text, bool condition) {
    return Row(
      children: [
        Icon(Icons.check, color: condition ? green : Colors.grey, size: 18),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                color: condition ? green : const Color(0xFF666666),
                fontSize: 15)),
      ],
    );
  }

  Widget _buildStrengthBar(int level) {
    Color color;
    switch (level) {
      case 3:
        color = green;
        break;
      case 2:
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
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
