import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone_trial_01/appbar.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  int _selectedTabIndex = 0;
  List<dynamic> inquiries = [];

  @override
  void initState() {
    super.initState();
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/mypage/inquiries?user_id=683dc52eb059f8754e24303e');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          inquiries = json.decode(response.body);
        });
      } else {
        print('❌ 1:1 문의 목록 조회 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['1:1 문의하기', '나의 문의 내역'];

    return Scaffold(
      appBar: const CustomAppBar(title: '1대1 문의하기'),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = index == _selectedTabIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTabIndex = index),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        color: isSelected ? const Color(0xFF37966F) : Colors.transparent,
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
          const Divider(height: 1),
          Expanded(
            child: _selectedTabIndex == 0
                ? const InquiryForm()
                : InquiryHistory(inquiries: inquiries),
          ),
        ],
      ),
    );
  }
}

class InquiryForm extends StatefulWidget {
  const InquiryForm({super.key});

  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text('제목 *', style: TextStyle(fontSize: 18, color: Colors.black)),
          const TextField(decoration: InputDecoration(hintText: '제목을 입력하세요')),

          const SizedBox(height: 20),
          const Text('문의내용 *', style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          const TextField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: '내용을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),
          const Text('첨부파일', style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera, size: 40, color: Colors.grey[700]),
              const SizedBox(width: 50),
              Icon(Icons.photo_camera, size: 40, color: Colors.grey[700]),
              const SizedBox(width: 50),
              Icon(Icons.photo_camera, size: 40, color: Colors.grey[700]),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '최대 10MB 이하, 3개까지 등록 가능',
            style: TextStyle(fontSize: 15, color: Color(0xFF616161)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                activeColor: const Color(0xFFA8DAB5),
              ),
              const Expanded(
                child: Text(
                  '개인정보 수집 및 이용 동의',
                  style: TextStyle(fontSize: 15, color: Color(0xFF616161)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF37966F)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Color(0xFF37966F), fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37966F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    '작성 완료',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class InquiryHistory extends StatelessWidget {
  final List<dynamic> inquiries;

  const InquiryHistory({super.key, required this.inquiries});

  String formatDate(dynamic date) {
    try {
      return date.toString().substring(0, 10);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: inquiries.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = inquiries[index];

        final isAnswered = item['status'] == '답변 완료';
        final answerText = item['answer'] ?? '';
        final answeredAt = item['answered_at'];

        final contentText = item['content'] ?? '';
        final createdAt = formatDate(item['created_at']);

        return ExpansionTile(
  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          item['title'] ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        item['status'] ?? '',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isAnswered ? const Color(0xFF37966F) : Colors.black87,
        ),
      ),
    ],
  ),
  children: [
    const SizedBox(height: 6),
    const Text('문의 내용', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.black)),
    const SizedBox(height: 4),
    Text(contentText, style: const TextStyle(fontSize: 14, color: Colors.black)),
    const SizedBox(height: 8),
    Text('문의 시간: $createdAt', style: const TextStyle(fontSize: 12, color: Colors.black)),

    // ✅ 이미지 표시 영역
    if ((item['images'] as List?)?.isNotEmpty ?? false) ...[
      const SizedBox(height: 12),
      SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: item['images'].length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['images'][i],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            );
          },
        ),
      ),
    ],

    // ✅ 답변 영역
    if (isAnswered && answerText.isNotEmpty) ...[
      const SizedBox(height: 16),
      const Text('답변 내용', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.black)),
      const SizedBox(height: 4),
      Text(answerText, style: const TextStyle(fontSize: 14,color: Colors.black)),
      if (answeredAt != null && answeredAt != '')
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('답변 시간: $answeredAt', style: const TextStyle(fontSize: 12, color: Colors.black)),
        ),
    ],
  ],
);

      },
    );
  }
}
