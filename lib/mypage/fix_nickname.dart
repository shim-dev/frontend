import 'package:flutter/material.dart';
import 'package:shim/mypage/appbar.dart';
import 'package:shim/DB/mypage/db_mypage.dart'; 

class ChangeNicknamePage extends StatefulWidget {
  const ChangeNicknamePage({super.key});

  @override
  State<ChangeNicknamePage> createState() => _ChangeNicknamePageState();
}

class _ChangeNicknamePageState extends State<ChangeNicknamePage> {
  final Color green = const Color(0xFF37966F);
  final Color hoverGreen = const Color(0xFF76D9A8);

  final TextEditingController _controller = TextEditingController();
  String? errorText;
  bool isValid = false;

  void validate(String val) {
    final trimmed = val.trim();
    if (trimmed.length < 2 || trimmed.length > 10) {
      setState(() {
        errorText = '닉네임을 2~10자로 입력해주세요.';
        isValid = false;
      });
    } else {
      setState(() {
        errorText = null;
        isValid = true;
      });
    }
  }

  void handleSubmit() async {
  final nickname = _controller.text.trim();
  if (!isValid) return;

  final success = await updateNickname(nickname); 

  if (success) {
    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임이 성공적으로 변경되었습니다.')),
      );
    }
  } else {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임 변경에 실패했습니다.')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '닉네임 변경'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              '새로운 닉네임을 입력해주세요',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
            controller: _controller,
            onChanged: validate,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black, // 입력 텍스트 색 진하게
            ),
            decoration: InputDecoration(
              hintText: '닉네임',
              hintStyle: const TextStyle(
                color: Color(0xFF999999), // 힌트 텍스트도 좀 더 진하게
                fontSize: 16,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        validate('');
                      },
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF37966F), width: 1.5), // 민트색 테두리
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF37966F), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
            const Spacer(),
            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isValid ? handleSubmit : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade300;
                    }
                    return green;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey.shade600;
                    }
                    return Colors.white;
                  },
                ),
                minimumSize: MaterialStateProperty.all(const Size.fromHeight(52)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: const Text(
                '변경 완료',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
