import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bookmark.dart';
import 'event.dart';
import 'fix_myProfile.dart'; 

class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MypageAppBar(title: '마이페이지'),
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

class MypageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? action;

  const MypageAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: onBack == null
          ? null // 뒤로가기 버튼을 제거
          : IconButton(
              icon: SvgPicture.asset(
                'assets/icon/arrow_back.svg',
                width: 32,
                height: 32,
              ),
              onPressed: onBack ?? () => Navigator.pop(context),
            ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: action != null ? [action!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

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
          backgroundImage: AssetImage('assets/profile_sample/mococo.png'),
          backgroundColor: Colors.deepPurple,
        ),

        SizedBox(height: screenHeight * 0.022),
        // 닉네임 + 오른쪽 화살표 (터치 가능)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FixMyProfile()),
            );
          },
          child: Row(
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
        ),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookmarkPage()),
              );
            },
          ),
          _ShortcutItem(
            iconPath: 'assets/icon/event.svg',
            label: '이벤트',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const  EventPage()),
              );
            },
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
  final VoidCallback? onTap;

  const _ShortcutItem({
    required this.iconPath,
    required this.label,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth * 0.06;

    return GestureDetector(
      onTap: onTap, // ✅ 여기 연결
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(
              Color(0xFF69B294),
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
      ),
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
