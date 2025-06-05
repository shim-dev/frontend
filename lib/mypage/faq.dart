import 'package:flutter/material.dart';
import 'package:shim/DB/mypage/db_faq.dart';
import 'package:shim/mypage/appbar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<dynamic> faqList = [];

  @override
  void initState() {
    super.initState();
    fetchFaqs();
  }

  void fetchFaqs() async {
    final data = await fetchFaqsFromDB();
    if (data != null) {
      setState(() {
        faqList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '자주 묻는 질문'),
      backgroundColor: Colors.white,
      body:
          faqList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: faqList.length,
                separatorBuilder:
                    (context, index) => const Divider(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq['answer'] ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
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
