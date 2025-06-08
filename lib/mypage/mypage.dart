import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shim/DB/mypage/db_mypage.dart';
import 'bookmark.dart';
import 'event.dart';
import 'faq.dart';
import 'fix_myProfile.dart';
import 'inquiry.dart';
import 'logout.dart';
import 'notice.dart';
import 'terms.dart';

// 공식 민트 색상
const Color mainMint = Color(0xFF69B294);
const Color lightMint = Color(0xFF9CE5C7);
const Color darkMint = Color(0xFF367F61);

class MyTab extends StatefulWidget {
  const MyTab({super.key});

  @override
  State<MyTab> createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  Key profileKey = UniqueKey(); 
  void refreshProfile() {
    setState(() {
      profileKey = UniqueKey(); 
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MypageAppBar(title: '마이페이지'),
      backgroundColor: Colors.white,
      body: ListView(
      children: [
        MyProfile(key: profileKey), // 키로 상태 관리
        const MyShortcutRow(),
        const Settings(),
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
          ? null
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

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String nickname = '...';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {
    final data = await fetchUserInfo();
    if (data != null) {
      setState(() {
        nickname = data['nickname'] ?? '사용자';
        email = data['email'] ?? '1234@naver.com';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 닉네임 + 이메일
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '안녕하세요',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$nickname님',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          // 오른쪽 계정관리
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0), 
              child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FixMyProfile()),
                );
                if (result == true) {
                  final parentState = context.findAncestorStateOfType<_MyTabState>();
                  parentState?.refreshProfile(); 
                }
              },
              child: const Text(
                '계정관리',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

            ),
          ),
        ],
      ),
    );
  }
}

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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BookmarkPage()),
            ),
          ),
          _ShortcutItem(
            iconPath: 'assets/icon/event.svg',
            label: '이벤트',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EventPage()),
            ),
          ),
          _ShortcutItem(
            iconPath: 'assets/icon/notice.svg',
            label: '공지사항',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoticePage()),
            ),
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
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
            colorFilter: const ColorFilter.mode(mainMint, BlendMode.srcIn),
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

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isNotificationOn = false;

  @override
  void initState() {
    super.initState();
    loadUserSettings();
  }

  void loadUserSettings() async {
    final enabled = await fetchUserNotificationSetting();
    setState(() {
      _isNotificationOn = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingItem(
          iconPath: 'assets/icon/information.svg',
          label: '자주 묻는 질문',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FaqPage()),
          ),
        ),
        SettingItem(
          iconPath: 'assets/icon/paper.svg',
          label: '약관 확인',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TermsPage()),
          ),
        ),
        SettingItem(
          iconPath: 'assets/icon/chat.svg',
          label: '1대1 문의하기',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InquiryPage()),
          ),
        ),
        SettingItem(
          iconPath: 'assets/icon/logout.svg',
          label: '로그아웃',
          onTap: () => showLogoutDialog(context),
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
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.iconPath,
    required this.label,
    this.hasSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      mainMint,
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
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      activeColor: mainMint,
                      onChanged: onChanged,
                    ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE0E0E0), thickness: 1.0, height: 0),
          ],
        ),
      ),
    );
  }
}
