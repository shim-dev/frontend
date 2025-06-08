import 'package:flutter/material.dart';
import 'package:shim/DB/mypage/db_inquiry.dart';
import 'package:shim/mypage/appbar.dart';
import 'package:shim/DB/db_helper.dart';

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
    _fetchInquiries(); 
  }

  Future<void> _fetchInquiries() async {
    final data = await fetchInquiriesFromDB(); 
    if (data != null) {
      setState(() {
        inquiries = data;
      });
    }
  }

  void _handleInquirySubmitted() {
  setState(() {
    _selectedTabIndex = 1; // 문의 내역 탭으로 전환
  });
  _fetchInquiries(); // 최신 문의 내역 다시 불러오기
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
                        color:
                            isSelected
                                ? const Color(0xFF37966F)
                                : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const Divider(height: 1),
          Expanded(
          child: _selectedTabIndex == 0
              ? InquiryForm(onSubmitted: _handleInquirySubmitted)
              : InquiryHistory(inquiries: inquiries),
        ),
        ],
      ),
    );
  }
}

class InquiryForm extends StatefulWidget {
  final VoidCallback onSubmitted;
  const InquiryForm({super.key, required this.onSubmitted});

  @override
  State<InquiryForm> createState() => _InquiryFormState();
}

class _InquiryFormState extends State<InquiryForm> {
  bool isChecked = false;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> submitInquiry() async {
    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("개인정보 수집에 동의해주세요")),
      );
      return;
    }

    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목과 내용을 모두 입력해주세요")),
      );
      return;
    }

    final result = await postInquiryToDB(title, content);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("문의가 등록되었습니다")),
      );
      titleController.clear();
      contentController.clear();
      setState(() => isChecked = false);

      widget.onSubmitted();  // nquiryPage에 알림 → 탭 이동 + 목록 갱신
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text(
            '제목 *',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: '제목을 입력하세요'),
          ),
          const SizedBox(height: 20),
          const Text(
            '문의내용 *',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: contentController,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: '내용을 입력하세요',
              border: OutlineInputBorder(),
            ),
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
                  onPressed: () {
                    titleController.clear();
                    contentController.clear();
                    setState(() => isChecked = false);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF37966F)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                  onPressed: submitInquiry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37966F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
    if (inquiries.isEmpty) {
      return const Center(child: Text('문의 내역이 없습니다.'));
    }

    return ListView.separated(
      itemCount: inquiries.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = inquiries[index];
        final title = item['title'] ?? '';
        final content = item['content'] ?? '';
        final createdAt = formatDate(item['created_at']);
        final isAnswered = item['status'] == '답변 완료';
        final answer = item['answer'] ?? '';
        final answeredAt = item['answered_at'];

        return ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    createdAt,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  Text(
                    isAnswered ? '답변완료' : '답변대기',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isAnswered ? const Color(0xFF37966F) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            const Divider(),
            const Text('문의 내용', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
            const SizedBox(height: 4),
            Text(content, style: const TextStyle(color: Colors.black)),
            if (isAnswered && answer.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('답변 내용', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(answer, style: const TextStyle(color: Colors.black)),
              if (answeredAt != null && answeredAt != '')
                Text(
                  '답변일: $answeredAt',
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ],
        );
      },
    );
  }
}
