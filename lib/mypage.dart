import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:capstone_trial_01/appbar.dart'; 

class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '마이페이지'),
      backgroundColor: Colors.white,
      body: ListView(
        children: const [
          MyProfile(),
          MyShortcutRow(),
          Settings(),
        ],
      ),
    );
  }
}

//프로필 사진, 계정 정보
class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
      // 프로필 사진
       CircleAvatar(
          radius: screenWidth * 0.15,
          backgroundImage: AssetImage('assets/profile_sample/mococo.png'), //샘플 프로필 사진
          backgroundColor: Colors.deepPurple,
        ),

        SizedBox(height: screenHeight * 0.022),
      //닉네임
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
            'assets/icon/right_arrow.svg',
              width: 11,
              height: 18,
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.0003), 
        //이메일
        Text(
          'abcd1234@naver.com', //샘플이메일
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1, 
          ),
        ),

        SizedBox(height: screenHeight * 0.006),
      ],
    );
  }
}

//북마크, 이벤트, 공지사항
class MyShortcutRow extends StatelessWidget {
  const MyShortcutRow({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ShortcutItem(
            iconPath: 'assets/icon/bookmark.svg',
            label: '북마크',
          ),
          _ShortcutItem(
            iconPath: 'assets/icon/event.svg',
            label: '이벤트',
          ),
          _ShortcutItem(
            iconPath: 'assets/icon/notice.svg',
            label: '공지사항',
          ),
        ],
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const _ShortcutItem({
    required this.iconPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.06;

    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            const Color(0xFF69B294),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SettingItem(
          iconPath: 'assets/icon/bell.svg',
          label: '알림',
          hasSwitch: true,
        ),
        SettingItem(
          iconPath: 'assets/icon/information.svg',
          label: '고객센터',
        ),
        SettingItem(
          iconPath: 'assets/icon/paper.svg',
          label: '약관 확인',
        ),
        SettingItem(
          iconPath: 'assets/icon/logout.svg',
          label: '로그아웃',
        ),
      ],
    );
  }
}

class SettingItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool hasSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.label,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF69B294),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (hasSwitch)
                  Switch(
                    value: switchValue,
                    activeColor: const Color(0xFF69B294),
                    onChanged: onChanged,
                  )
              ],
            ),
          ),
          const Divider(
            color: Color(0xFFE0E0E0),
            thickness: 1.0,
            height: 0,
          ),
        ],
      ),
    );
  }
}
