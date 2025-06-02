import 'package:flutter/material.dart';
import 'search_result_screen.dart';
import 'recent_recipes.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> tabs = ['추천 검색어', '최근 본 레시피'];
  final List<String> tags = [
    '저당',
    '식물성 단백질',
    '항산화',
    '오메가3',
    '녹황색 채소 요리',
    '지중해식 식단',
    '건과류 샐러드',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 검색창
              TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultScreen(keyword: value),
                      ),
                    );
                  }
                },
                decoration: InputDecoration(
                  hintText: '음식/재료 검색',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      String value = _searchController.text.trim();
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchResultScreen(keyword: value),
                          ),
                        );
                      }
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),

              const SizedBox(height: 16),

              // 🟢 탭 전환
              Row(
                children: List.generate(tabs.length, (index) {
                  final selected = selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: selected ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // ✅ Body 영역 (추천 검색어 or 최근 본 레시피)
              Expanded(
                child: selectedTabIndex == 0
                    // 추천 검색어
                    ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tags.map((tag) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchResultScreen(keyword: tag),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(tag, style: const TextStyle(color: Colors.green)),
                            ),
                          );
                        }).toList(),
                      )
                    // 최근 본 레시피
                    : recentRecipes.isEmpty
                        ? const Center(
                            child: Text(
                              '최근 본 레시피가 없습니다.',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          )
                        : ListView.builder(
                            itemCount: recentRecipes.length,
                            itemBuilder: (context, index) {
                              final recipeTitle = recentRecipes[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RecipeDetailScreen(recipeTitle: recipeTitle),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 이미지
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            'https://placehold.co/100x100.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        // 오른쪽 정보
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // 제목
                                              Text(
                                                recipeTitle,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 6),

                                              // 해시태그
                                              const Text(
                                                '#식물성단백질  #두부면  #저탄수',
                                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                              const SizedBox(height: 6),

                                              // 설명
                                              const Text(
                                                '탄수화물 부담 없이 즐기는 저탄고단 태국식 볶음면',
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              const SizedBox(height: 8),

                                              // 아이콘 줄
                                              Row(
                                                children: const [
                                                  Icon(Icons.timer, size: 16),
                                                  SizedBox(width: 4),
                                                  Text('15분'),
                                                  SizedBox(width: 12),
                                                  Text('🔥 난이도 하'),
                                                  SizedBox(width: 12),
                                                  Text('🍽 1인분'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
