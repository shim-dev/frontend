import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:capstone_trial_01/appbar.dart';
import 'change_password.dart';
import 'withdrawal_screen.dart';

class FixMyProfile extends StatelessWidget {
  const FixMyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '개인 정보 수정'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          ProfileImagePicker(
            imageUrl: '', // 초기 이미지 URL
            onImagePick: () {
              // TODO: 이미지 선택 로직 구현
            },
          ),
          FixProfileOptions(),
        ],
      ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onImagePick;

  const ProfileImagePicker({
    super.key,
    required this.imageUrl,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),

        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.15,
              backgroundColor: const Color(0xFF1B5E20),
              child: CircleAvatar(
                radius: screenWidth * 0.12,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/profile_sample/mococo.png') as ImageProvider,
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onImagePick,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.022),

        // 닉네임 + 수정 아이콘
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '혜진',
              style: TextStyle(
                fontSize: screenWidth * 0.075,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            SvgPicture.asset(
              'assets/icon/edit.svg',
              width: 14,
              height: 14,
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }
}

class FixProfileOptions extends StatelessWidget {
  const FixProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'text': '비밀번호 변경', 'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
        );
      }},
      {'text': '건강 정보 수정하기', 'onTap': () => print('건강 정보 수정')},
            {
        'text': '탈퇴하기',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawalScreen()),
          );
        }
      },
    ];

    return Column(
      children: options.map((option) {
        return Column(
          children: [
            ListTile(
              title: Text(
                option['text'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black, 
                ),
              ),
              onTap: option['onTap'] as void Function(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
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
