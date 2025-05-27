import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  final List<Map<String, String>> faqList = const [
    {
      'question': '사진이 없는 음식은 칼로리 어떻게 보나요?',
      'answer': '텍스트로 입력된 음식명을 기반으로 영양 정보를 추정하여 칼로리를 제공합니다.'
    },
    {
      'question': '1:1 문의는 어디서 하나요?',
      'answer': '마이페이지 > 고객센터 > 1:1 문의를 통해 가능합니다.'
    },
    {
      'question': '탈퇴는 어떻게 하나요?',
      'answer': '마이페이지 > 개인정보 수정 > 회원 탈퇴를 통해 탈퇴할 수 있습니다.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '자주 묻는 질문'),
      backgroundColor: Colors.white,
      body: ListView.separated(
        itemCount: faqList.length,
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
          color: Color(0xFFE0E0E0),
          height: 0,
        ),
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            title: Text('Q. ${faq['question']}'),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(faq['answer'] ?? '', style: TextStyle(fontSize: 15, color: Colors.black)),
              ),
            ],
            iconColor: Colors.black87,
            collapsedIconColor: Colors.grey,
            textColor: Colors.black,
            collapsedTextColor: Colors.black87,
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          );
        },
      ),
    );
  }
}
