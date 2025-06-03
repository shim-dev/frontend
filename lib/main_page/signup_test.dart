import 'package:flutter/material.dart';
import 'package:shim/DB/db_user.dart';

import 'login_test_page.dart'; // <<== 로그인 페이지 import!
import 'main.dart'; // 필요시 실제 경로 맞추기

class SignupTestPage extends StatefulWidget {
  const SignupTestPage({Key? key}) : super(key: key);

  @override
  State<SignupTestPage> createState() => _SignupTestPageState();
}

class _SignupTestPageState extends State<SignupTestPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _signup() async {
    setState(() => _isLoading = true);
    try {
      await signup(
        email: emailController.text.trim(),
        nickname: nicknameController.text.trim(),
        password: passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FigmaToCodeApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('회원가입 실패: $e')));
    }
    setState(() => _isLoading = false);
  }

  // 👉 로그인 페이지로 이동
  void _goToLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => LoginTestPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입(테스트)')),
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
                controller: nicknameController,
                decoration: InputDecoration(labelText: '닉네임'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
              ),
              SizedBox(height: 28),
              ElevatedButton(
                onPressed: _isLoading ? null : _signup,
                child:
                    _isLoading
                        ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : Text('회원가입'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
              SizedBox(height: 16),
              // 🟢 로그인하기 버튼!
              TextButton(
                onPressed: _goToLogin,
                child: Text('이미 계정이 있나요? 로그인 하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
