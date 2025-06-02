// 필요한 패키지 임포트
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeTitle;

  const RecipeDetailScreen({super.key, required this.recipeTitle});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isBookmarked = false;

  // 공유 기능
  void _shareRecipe() {
    final url = 'https://example.com/recipe/${widget.recipeTitle}';
    Share.share('맛있는 레시피를 공유해요! 🥢\n$url');
  }

  // 유튜브 링크 열기
  void _launchYouTube() async {
    final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ');

    if (await canLaunchUrl(youtubeUrl)) {
      await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유튜브 링크를 열 수 없습니다.')),
      );
    }
  }

  // ✅ 재료 리스트 (원하는 만큼 추가 가능!)
  final List<String> ingredients = [
    '두부',
    '새우',
    '숙주',
    '부추',
    '계란',
  ];

  // ✅ 쿠팡 검색 링크 자동 생성
  late final List<String> coupangLinks = ingredients.map((ingredient) {
    return 'https://www.coupang.com/np/search?component=&q=${Uri.encodeComponent(ingredient)}';
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareRecipe,
          ),
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 + 텍스트 오버레이
            Stack(
              children: [
                Image.network(
                  'https://placehold.co/350x320.png',
                  width: double.infinity,
                  height: 320,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      widget.recipeTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // "재료" 박스
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Text(
                              '재료 ${ingredients.length}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: ingredients.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://picsum.photos/60/60?random=$index',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(ingredients[index]),
                                    subtitle: Wrap(
                                      spacing: 6,
                                      children: const [
                                        Chip(
                                          label: Text('#태그1', style: TextStyle(fontSize: 12)),
                                          backgroundColor: Color(0xFFE0F2F1),
                                        ),
                                        Chip(
                                          label: Text('#태그2', style: TextStyle(fontSize: 12)),
                                          backgroundColor: Color(0xFFE0F2F1),
                                        ),
                                      ],
                                    ),
                                    trailing: ElevatedButton.icon(
                                      onPressed: () async {
                                        final Uri url = Uri.parse(coupangLinks[index]);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('링크를 열 수 없습니다.')),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                                      label: const Text('이동'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(color: Colors.black12),
                                        textStyle: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFCFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '재료',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 28,
                        width: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ingredients.length.clamp(0, 4), // 최대 4개까지만 표시
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      'https://picsum.photos/seed/icon$index/28/28',
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (index == 3 && ingredients.length > 4)
                                    Positioned.fill(
                                      child: Center(
                                        child: Text(
                                          '+${ingredients.length - 3}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 조리 순서
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '1. 두부면과 숙주를 물에 가볍게 헹군 후 물기 제거.\n'
                '2. 냉동 새우 해동 후 물기 제거.\n'
                '3. 채소 썰기.\n'
                '4. 팬에 기름을 두르고 재료 순서대로 볶기.\n'
                '5. 소스 넣고 볶아 마무리.\n'
                '6. 플레이팅 후 토핑 추가!',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
              ),
            ),

            const SizedBox(height: 24),

            // 유튜브 링크 Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFCFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://placehold.co/80x60.png',
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: const Text(
                    '두부 팟타이',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'youtube',
                    style: TextStyle(fontSize: 13),
                  ),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: _launchYouTube,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
