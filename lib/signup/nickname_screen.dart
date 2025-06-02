import 'package:flutter/material.dart';
import 'birth_screen.dart';
import '../DB/signup/DB_nickname.dart';


// <- 커스텀 화살표 아이콘
class LeftArrowIcon extends StatelessWidget {
  const LeftArrowIcon({super.key, this.color = Colors.black, this.size = 24});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_back,
      color: color,
      size: size,
    );
  }
}

class NicknameScreen extends StatefulWidget {
  final String userId;
  const NicknameScreen({super.key, required this.userId});

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _nicknameError;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_update);
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _nicknameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final padding = deviceWidth * 0.07;

    // 진행바 (2/8단계 예시)
    const totalSteps = 8;
    final currentStep = 1;
    final progressValue = currentStep / totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(deviceHeight * 0.085),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const LeftArrowIcon(),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            '닉네임',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressValue,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8F80F9), Color(0xFF5ED593)],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: deviceHeight * 0.05),
            Image.asset(
              'assets/icon/turtle_nickname.png',
              width: deviceWidth * 0.7,
              height: deviceWidth * 0.7,
            ),
            SizedBox(height: deviceHeight * 0.03),
            const Text(
              '반가워요!\n어떻게 불러드릴까요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Colors.black,
              ),
            ),
            SizedBox(height: deviceHeight * 0.05),

            // 닉네임 입력
            Stack(
              children: [
                TextFormField(
                  controller: _nicknameController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: '닉네임 (2~12자리 한글/영문/숫자)',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                  style: const TextStyle(fontSize: 17),
                ),
                // 그라데이션/회색 밑줄 (밑에 깔기)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: _focusNode.hasFocus
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
            ),

            // 밑줄 바로 아래 메시지
            SizedBox(height: 8),
            Builder(
              builder: (context) {
                if (_nicknameController.text.isEmpty) return const SizedBox.shrink();
                if (_nicknameError != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.close, color: Colors.red, size: 18),
                      const SizedBox(width: 2),
                      Text(
                        _nicknameError!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ],
                  );
                }
                if (_isAvailable) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.check, color: Color(0xFF0A8356), size: 18),
                      const SizedBox(width: 2),
                      const Text(
                        '사용 가능한 닉네임입니다.',
                        style: TextStyle(color: Color(0xFF0A8356), fontSize: 13),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const Spacer(),
            // 다음 버튼
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
                    final nickname = _nicknameController.text.trim();

                    if (!RegExp(r'^[가-힣a-zA-Z0-9]{2,12}$').hasMatch(nickname)) {
                      setState(() {
                        _nicknameError = '2~12자리 한글/영문/숫자만 입력 가능해요.';
                      });
                      return;
                    }

                    final result = await setNickname(widget.userId, nickname);
                    if (result['success']) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BirthScreen(userId: widget.userId))

                      );
                    } else {
                      setState(() {
                        _nicknameError = result['message'];
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
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }
}
