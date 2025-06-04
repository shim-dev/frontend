import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 디바이스 크기
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    // 비율로 UI 요소 크기 조정
    final topSpacer = deviceHeight * 0.12;    // 최상단 여백 (약 12%)
    final imgSize = deviceWidth * 0.55;       // 로고 이미지 가로/세로 (55%)
    final horizontalPadding = deviceWidth * 0.08; // 양 옆 패딩 (8%)

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: topSpacer),
                // 로고 이미지
                Image.asset(
                  'assets/icon/turtle.png',
                  width: imgSize,
                  height: imgSize,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: deviceHeight * 0.04),
                // 인사 텍스트
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: '안녕하세요!\n당신의 저속노화 메이트,\n',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GradientText(
                          '쉼; SHIM',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.5,
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                          ),
                        ),
                      ),
                      const TextSpan(
                        text: '에 오신걸\n환영합니다.',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: deviceHeight * 0.04),

                const Text(
                  'SNS계정으로 로그인하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: deviceHeight * 0.022),

                // SNS 버튼들 (네이버, 카카오, 페북, 애플)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _snsCircleIcon('assets/icon/login_naver.png'),
                    _snsCircleIcon('assets/icon/login_kakao.png'),
                    _snsCircleIcon('assets/icon/login_facebook.png'),
                    _snsCircleIcon('assets/icon/login_apple.png'),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.04),

                // 간편가입 버튼
                GradientOutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  borderRadius: 30,
                  borderWidth: 1.5,
                  child: const Text(
                    '계정이 없으신가요? 간편가입하기',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.018),

                /*const Text(
                  '이미 아이디가 있으신가요?',
                  style: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),*/

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    '이미 아이디가 있으신가요?',
                    style: TextStyle(
                      color: Color(0xFFA0A0A0),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.04),

                // 하단 슬로건
                Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.03),
                  child: Column(
                    children: const [
                      Text(
                        'SHIM Lab.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Slow, Heal, Inspire, Mindfulness',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // SNS 아이콘 원형 컨테이너
  static Widget _snsCircleIcon(String assetPath) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
// -------------------- //
// 그라데이션 텍스트용 위젯
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
      this.text, {
        super.key,
        required this.style,
        required this.gradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

// 그라데이션 아웃라인 버튼
class GradientOutlinedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;
  final Color backgroundColor;

  const GradientOutlinedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 30,
    this.borderWidth = 1.5,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
    ),
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          margin: EdgeInsets.all(borderWidth),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
