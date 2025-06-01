import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  int _selectedTabIndex = 0;

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
                : const InquiryHistory(),
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
          const SizedBox(height: 20), // 버튼 아래 여백
        ],
      ),
    );
  }
}

class InquiryHistory extends StatelessWidget {
  const InquiryHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {
        'title': '비밀번호를 변경했는데 까먹었어요',
        'date': '2025-05-01',
        'status': '답변대기',
        'answer': '',
      },
      {
        'title': '북마크가 전부 사라졌어요 복구해주세요',
        'date': '2025-05-01',
        'status': '답변완료',
        'answer': '안녕하세요. 요청하신 북마크 복구를 완료하였습니다.',
      },
    ];

    return ListView.separated(
      itemCount: dummyData.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = dummyData[index];

        return ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title']!,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    const SizedBox(height: 4),
                    Text(item['date']!,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                item['status']!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: item['status'] == '답변완료'
                      ? const Color(0xFF37966F)
                      : Colors.grey[800],
                ),
              ),
            ],
          ),
          children: [
            if (item['status'] == '답변완료')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(item['answer'] ?? '',
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
              ),
          ],
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.only(bottom: 12),
        );
      },
    );
  }
}