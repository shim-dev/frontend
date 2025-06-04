import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shim/main_page/signup_test.dart';

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
      ).pushReplacement(MaterialPageRoute(builder: (_) => SignupTestPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Splash...')),
    );
  }
}
