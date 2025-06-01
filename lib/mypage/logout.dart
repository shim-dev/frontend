import 'package:flutter/material.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        '로그아웃',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      content: const Text(
        '로그아웃 하시겠습니까?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF37966F)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            '취소',
            style: TextStyle(color: Color(0xFF37966F), fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // 여기에 실제 로그아웃 로직 추가
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF37966F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text('확인', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end, // 버튼 오른쪽 정렬
    ),
  );
}
