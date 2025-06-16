import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shim/signup/welcome_screen.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), _checkAutoLogin);
  }

  Future<void> _checkAutoLogin() async {
    String? userId = await _storage.read(key: 'user_id');
    if (!mounted) return;
    if (userId != null && userId.isNotEmpty) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => FigmaToCodeApp()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // 거북이 이미지
              Image.asset(
                'assets/icon/slowfood_turtle.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              // Shim 텍스트
              Text(
                'S  h  i  m',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 15,
                  fontFamily: 'Thin',
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // 하단 Lab 및 슬로건
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    Text(
                      'Shim. Lab',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Slow. Heal. Inspire. Mindfulness',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                        height: 1.38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   final FlutterSecureStorage _storage = FlutterSecureStorage();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 2), _checkAutoLogin);
//   }
//
//   Future<void> _checkAutoLogin() async {
//     String? userId = await _storage.read(key: 'user_id');
//     if (!mounted) return;
//     if (userId != null && userId.isNotEmpty) {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => FigmaToCodeApp()));
//     } else {
//       Navigator.of(
//         context,
//       ).pushReplacement(MaterialPageRoute(builder: (_) => WelcomeScreen()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: Text('Splash...')),
//     );
//   }
// }
