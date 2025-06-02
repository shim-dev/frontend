import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:capstone_trial_01/appbar.dart';

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

  Future<void> fetchFaqs() async {
    final url = Uri.parse('http://127.0.0.1:5000/api/mypage/faq');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          faqList = json.decode(response.body);
        });
      } else {
        print('❌ FAQ 불러오기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '자주 묻는 질문'),
      backgroundColor: Colors.white,
      body: faqList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          faq['answer'] ?? '',
                          style: const TextStyle(fontSize: 15, color: Colors.black),
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
