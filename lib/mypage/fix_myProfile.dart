import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shim/DB/mypage/db_mypage.dart'; 
import 'package:shim/mypage/appbar.dart';
import 'fix_nickname.dart';
import 'change_password.dart';
import 'withdrawal_screen.dart';

class FixMyProfile extends StatefulWidget {
  const FixMyProfile({super.key});

  @override
  State<FixMyProfile> createState() => _FixMyProfileState();
}

class _FixMyProfileState extends State<FixMyProfile> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(title: '개인 정보 수정'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: screenHeight * 0.04),
          const FixProfileOptions(),
        ],
      ),
    );
  }
}

class FixProfileOptions extends StatefulWidget {
  const FixProfileOptions({super.key});

  @override
  State<FixProfileOptions> createState() => _FixProfileOptionsState();
}

class _FixProfileOptionsState extends State<FixProfileOptions> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'text': '닉네임 변경',
        'onTap': () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangeNicknamePage()),
        );

        if (result == true && context.mounted) {
          Navigator.pop(context, true); 
        }
      },
      },
      {
        'text': '비밀번호 변경',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
          );
        },
      },
      {'text': '건강 정보 수정하기', 'onTap': () => print('건강 정보 수정')},
      {
        'text': '탈퇴하기',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawalScreen()),
          );
        },
      },
    ];

    return Column(
      children: options.map((option) {
        return Column(
          children: [
            ListTile(
              title: Text(
                option['text'],
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              onTap: option['onTap'] as void Function(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 8,
              ),
            ),
            const Divider(
              color: Color(0xFFE0E0E0),
              thickness: 1.0,
              height: 1,
              indent: 35,
              endIndent: 35,
            ),
          ],
        );
      }).toList(),
    );
  }
}

