import 'package:flutter/material.dart';
import 'nickname_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _customDomainController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _customDomainFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();

  String? _selectedDomain = 'gmail.com';
  final List<String> _domainOptions = [
    'gmail.com',
    'naver.com',
    'hanmail.net',
    'daum.net',
    'nate.com',
    '직접 입력',
  ];

  // 가상 "이미 가입된 이메일"
  final List<String> _dummyUsedEmailList = [
    'chaelim@gmail.com',
    'admin@naver.com',
    'test@hanmail.net'
  ];

  String? _emailError;
  String? _pwError;
  String? _pw2Error;

  @override
  void initState() {
    super.initState();
    _emailIdController.addListener(_validateEmail);
    _customDomainController.addListener(_validateEmail);
    _passwordController.addListener(_validatePw);
    _passwordConfirmController.addListener(_validatePw2);

    _emailFocus.addListener(_updateState);
    _customDomainFocus.addListener(_updateState);
    _passwordFocus.addListener(_updateState);
    _passwordConfirmFocus.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  String get fullEmail {
    final id = _emailIdController.text.trim();
    final domain = _selectedDomain == '직접 입력'
        ? _customDomainController.text.trim()
        : _selectedDomain ?? '';
    return (id.isNotEmpty && domain.isNotEmpty) ? '$id@$domain' : '';
  }

  void _validateEmail() {
    final email = fullEmail;
    if (_emailIdController.text.isEmpty) {
      _emailError = null;
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+$").hasMatch(_emailIdController.text.trim())) {
      _emailError = '이메일 아이디 형식이 올바르지 않습니다.';
    } else if (_selectedDomain == '직접 입력' && !_customDomainController.text.contains('.')) {
      _emailError = '도메인을 올바르게 입력하세요 (예: domain.com)';
    } else if (email.isNotEmpty && _dummyUsedEmailList.contains(email)) {
      _emailError = '이미 가입된 이메일입니다.';
    } else {
      _emailError = null;
    }
    setState(() {});
  }

  void _validatePw() {
    final pw = _passwordController.text;
    if (pw.isEmpty) {
      _pwError = null;
    } else if (pw.length < 8 ||
        !RegExp(r'[A-Za-z]').hasMatch(pw) ||
        !RegExp(r'[0-9]').hasMatch(pw) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pw)) {
      _pwError = '영문, 숫자, 특수문자 조합 8자 이상 입력';
    } else {
      _pwError = null;
    }
    setState(() {});
    _validatePw2();
  }

  void _validatePw2() {
    final pw = _passwordController.text;
    final pw2 = _passwordConfirmController.text;
    if (pw2.isEmpty) {
      _pw2Error = null;
    } else if (pw != pw2) {
      _pw2Error = '비밀번호가 일치하지 않습니다.';
    } else {
      _pw2Error = null;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _customDomainController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailFocus.dispose();
    _customDomainFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmFocus.dispose();
    super.dispose();
  }

  bool get isAllFilled {
    final domainFilled = _selectedDomain == '직접 입력'
        ? _customDomainController.text.trim().isNotEmpty
        : true;
    return _emailIdController.text.trim().isNotEmpty &&
        domainFilled &&
        _passwordController.text.trim().isNotEmpty &&
        _passwordConfirmController.text.trim().isNotEmpty &&
        _emailError == null &&
        _pwError == null &&
        _pw2Error == null;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final basePadding = deviceWidth * 0.07;
    final baseFontSize = deviceWidth * 0.045;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: basePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: deviceHeight * 0.03),
              Text(
                '이메일',
                style: TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: deviceHeight * 0.012),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 4,
                    child: GradientUnderlineTextField(
                      controller: _emailIdController,
                      hintText: '이메일',
                      focusNode: _emailFocus,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('@', style: TextStyle(color: Colors.black)),
                  ),
                  Expanded(
                    flex: 4,
                    child: _selectedDomain == '직접 입력'
                        ? Row(
                      children: [
                        Expanded(
                          child: GradientUnderlineTextField(
                            controller: _customDomainController,
                            hintText: '직접 입력',
                            focusNode: _customDomainFocus,
                          ),
                        ),
                        // ↓↓ 복귀 버튼!
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                          tooltip: '도메인 선택으로 변경',
                          onPressed: () {
                            setState(() {
                              _selectedDomain = 'gmail.com'; // 기본값 등으로 복귀!
                              _customDomainController.clear();
                            });
                          },
                        ),
                      ],
                    )
                        : DropdownButtonFormField<String>(
                      value: _selectedDomain,
                      items: _domainOptions.map((domain) {
                        return DropdownMenuItem(
                          value: domain,
                          child: Text(domain, style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDomain = value;
                          if (value != '직접 입력') {
                            _customDomainController.clear();
                          }
                        });
                        _validateEmail();
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 8, left: 6),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(_emailError!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ],
                  ),
                ),
              SizedBox(height: deviceHeight * 0.024),
              Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: baseFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: deviceHeight * 0.012),
              GradientUnderlineTextField(
                controller: _passwordController,
                hintText: '영문, 숫자, 특수문자 조합 8자 이상',
                obscureText: true,
                showClearButton: _passwordController.text.isNotEmpty,
                focusNode: _passwordFocus,
                errorText: _pwError,
              ),
              if (_pwError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(_pwError!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ],
                  ),
                ),
              SizedBox(height: deviceHeight * 0.024),
              GradientUnderlineTextField(
                controller: _passwordConfirmController,
                hintText: '비밀번호 재입력',
                obscureText: true,
                showClearButton: _passwordConfirmController.text.isNotEmpty,
                focusNode: _passwordConfirmFocus,
                errorText: _pw2Error,
              ),
              if (_pw2Error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(_pw2Error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ],
                  ),
                ),
              const Spacer(),

              // 가입하기 버튼
              SizedBox(
                width: double.infinity,
                height: deviceHeight * 0.06, // (예: 40~60px 내외)
                child: isAllFilled
                    ? DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NicknameScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.zero, // 텍스트 정중앙
                    ),
                    child: const Text(
                      '가입하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                )
                    : ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    '가입하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),
              const Column(
                children: [
                  Text(
                    'SHIM Lab.',
                    style: TextStyle(
                      fontSize: 14,
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
              SizedBox(height: deviceHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

// 각 입력란마다 밑줄
class GradientUnderlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool showClearButton;
  final FocusNode? focusNode;
  final String? errorText;
  final bool enabled;
  final bool readOnly;
  final void Function()? onTap;

  const GradientUnderlineTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.showClearButton = false,
    this.focusNode,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    final hasFocus = focusNode?.hasFocus ?? false;
    final fontSize = deviceWidth * 0.043; // 16~18px 전후
    final hintFontSize = deviceWidth * 0.035; // 13~15px 전후
    final paddingV = deviceHeight * 0.012; // 세로 padding
    final underlineHeight = deviceHeight * 0.0022; // 약 1.7~2.5px, 최소/최대 제한

    return Stack(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          focusNode: focusNode,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: hintFontSize, color: Colors.grey),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: showClearButton
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
              onPressed: () => controller.clear(),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: paddingV),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: underlineHeight.clamp(1.4, 2.5), // 최소 1.4, 최대 2.5로 제한
            decoration: BoxDecoration(
              gradient: hasFocus
                  ? const LinearGradient(
                colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
              )
                  : const LinearGradient(
                colors: [Colors.grey, Colors.grey],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
