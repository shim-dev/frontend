import 'package:flutter/material.dart';
import '../main.dart';
import '../DB/signup/DB_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController customDomainController = TextEditingController();

  final FocusNode _idFocus = FocusNode();
  final FocusNode _pwFocus = FocusNode();
  final FocusNode _customDomainFocus = FocusNode();
  String? _loginError;

  String? selectedDomain = 'naver.com';
  final List<String> domainOptions = [
    'naver.com',
    'gmail.com',
    'daum.net',
    'hanmail.net',
    '직접 입력',
  ];

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    customDomainController.dispose();
    _idFocus.dispose();
    _pwFocus.dispose();
    _customDomainFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final labelFontSize = deviceWidth * 0.045;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '로그인',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight * 0.05),
              Text('아이디', style: TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.w600, color: Colors.black)),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: GradientUnderlineTextField(
                      controller: idController,
                      hintText: '아이디를 입력하세요',
                      focusNode: _idFocus,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Text('@')),
                  Expanded(
                    flex: 7,
                    child: selectedDomain == '직접 입력'
                        ? Row(
                      children: [
                        Expanded(
                          child: GradientUnderlineTextField(
                            controller: customDomainController,
                            hintText: '직접 입력',
                            focusNode: _customDomainFocus,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              selectedDomain = 'naver.com';
                              customDomainController.clear();
                            });
                          },
                        )
                      ],
                    )
                        : DropdownButtonFormField<String>(
                      value: selectedDomain,
                      items: domainOptions.map((domain) {
                        return DropdownMenuItem(
                          value: domain,
                          child: Text(domain, style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedDomain = value);
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 8, left: 6),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(height: deviceHeight * 0.045),
              Text('비밀번호', style: TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.w600, color: Colors.black)),
              SizedBox(height: 5),
              GradientUnderlineTextField(
                controller: pwController,
                hintText: '비밀번호를 입력해주세요.',
                obscureText: true,
                focusNode: _pwFocus,
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: deviceHeight * 0.06,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final domain = selectedDomain == '직접 입력'
                              ? customDomainController.text
                              : selectedDomain;
                          final email = "${idController.text}@$domain";
                          final password = pwController.text;

                          final result = await loginUser(email, password); // 실제 로그인 요청

                          if (result['success']) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExampleScreen(/*userId: result['userId']*/), // 메인 페이지 이동
                              ),
                            );
                          } else {
                            setState(() {
                              _loginError = result['message']; // 아래 UI에 에러 메시지 표시
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('로그인', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ),
                  if (_loginError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _loginError!,
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),

                  SizedBox(height: deviceHeight * 0.03),
                  const Text('SHIM Lab.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
                  const Text('Slow, Heal, Inspire, Mindfulness',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black)),
                  SizedBox(height: deviceHeight * 0.03),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 공통 밑줄 컴포넌트
class GradientUnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;

  const GradientUnderlineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final hasFocus = focusNode?.hasFocus ?? false;

    return Stack(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          style: TextStyle(fontSize: deviceWidth * 0.043),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: deviceWidth * 0.035, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: deviceHeight * 0.012),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: (deviceHeight * 0.0022).clamp(1.4, 2.5),
            decoration: BoxDecoration(
              gradient: hasFocus
                  ? const LinearGradient(colors: [Color(0xFF8F80F9), Color(0xFF5ED593)])
                  : const LinearGradient(colors: [Colors.grey, Colors.grey]),
            ),
          ),
        )
      ],
    );
  }
}
