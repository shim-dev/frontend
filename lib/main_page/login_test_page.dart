import 'package:flutter/material.dart';
import 'package:shim/DB/db_user.dart';

import 'main.dart'; // 필요시 실제 경로 맞추기

class LoginTestPage extends StatefulWidget {
  const LoginTestPage({Key? key}) : super(key: key);

  @override
  State<LoginTestPage> createState() => _LoginTestPageState();
}

class _LoginTestPageState extends State<LoginTestPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      // DBHelper.login()이 true/false, 토큰, 유저정보 등 반환한다고 가정
      await login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FigmaToCodeApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인(테스트)')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child:
                    _isLoading
                        ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text('로그인'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
