import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  bool _agreed = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(title: '비밀번호 변경'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            const Text(
              '혜진님,\n정말 탈퇴하시겠어요?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            _warning('지금 탈퇴하시면 모든 기록이 함께 사라져요.\n추후에 동일 계정으로 재가입하셔도 복구되지 않아요!'),
            SizedBox(height: screenHeight * 0.01),
            _warning('지금 탈퇴하시면 저속노화 레시피 추천을\n더 이상 이용하실 수 없게 돼요!'),
            SizedBox(height: screenHeight * 0.025),
            Row(
              children: [
                Checkbox(
                  value: _agreed,
                  onChanged: (value) {
                    setState(() => _agreed = value!);
                  },
                  activeColor: const Color(0xFF37966F),
                ),
                const Expanded(
                  child: Text(
                    '회원 탈퇴 유의사항을 확인하였으며 동의합니다.',
                    style: TextStyle(color: Colors.black,
                      fontSize: 16,),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            const Text(
              '떠나시는 이유를 알려주세요.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration.collapsed(
                  hintText: '서비스 탈퇴 사유에 대해 알려주세요.\n고객님의 소중한 피드백을 담아\n더 나은 서비스로 보답 드리도록 하겠습니다.',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
              SizedBox(height: screenHeight * 0.05),
              if (_agreed)
                Row(
                  children: [
                    // 취소 버튼
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF37966F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 탈퇴 버튼
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            // 탈퇴 처리 로직
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF37966F), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            '회원 탈퇴',
                            style: TextStyle(fontSize: 18, color: Color(0xFF37966F)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: screenHeight * 0.03), // 버튼 아래 여백
                        ],
                      ),
                    ),
                  );
                } // <-- build 함수 닫는 중괄호

                // ✅ 여기는 build 바깥에 있어야 함
                Widget _warning(String text) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  );
                }
              }

  Widget _warning(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: Colors.black),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }

