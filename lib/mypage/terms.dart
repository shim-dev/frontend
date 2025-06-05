import 'package:flutter/material.dart';
import 'package:shim/mypage/appbar.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '약관 확인'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            Text(
              '개인정보 수집 및 이용 동의',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '''
1. 수집 항목
- 필수 항목: 이름, 이메일, 비밀번호
- 선택 항목: 프로필 사진, 생년월일 등

2. 수집 목적
- 서비스 제공 및 회원관리
- 고객 문의 응대
- 마케팅 및 이벤트 안내 (선택 동의 시)

3. 보유 및 이용 기간
- 회원 탈퇴 시까지 (관계법령에 따라 일정 기간 보관 가능)

4. 동의를 거부할 권리
- 동의를 거부할 수 있으나, 이 경우 서비스 이용에 제한이 있을 수 있습니다.

기타 자세한 내용은 [개인정보 처리방침]을 참고해주세요.
              ''',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
