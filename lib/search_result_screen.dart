import 'package:flutter/material.dart';
import 'recent_recipes.dart';
import 'recipe_detail_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;
  const SearchResultScreen({super.key, required this.keyword});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  // ✅ Map 구조 → date + views 포함
  List<Map<String, dynamic>> dummyRecipes = [
    {
      'title': '두부면 팟타이',
      'date': DateTime(2024, 6, 1),
      'views': 120,
    },
    {
      'title': '초간단 두부면 레시피',
      'date': DateTime(2024, 6, 2),
      'views': 80,
    },
    {
      'title': '두부면 간장 국수',
      'date': DateTime(2024, 5, 28),
      'views': 200,
    },
    {
      'title': '두부면 알리오 올리오',
      'date': DateTime(2024, 5, 30),
      'views': 150,
    },
  ];

  int selectedTabIndex = 0;
  final List<String> tabs = ['최신순', '조회순'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 상단 → 뒤로가기 + 검색창
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: widget.keyword),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: '검색어 입력',
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ 최신순 / 조회순 → 오른쪽 정렬
              Row(
                children: [
                  const Spacer(),
                  Row(
                    children: List.generate(tabs.length, (index) {
                      final selected = selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                            if (selectedTabIndex == 0) {
                              // 최신순
                              dummyRecipes.sort((a, b) => b['date'].compareTo(a['date']));
                            } else {
                              // 조회순
                              dummyRecipes.sort((a, b) => b['views'].compareTo(a['views']));
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: selected ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ 레시피 리스트
              Expanded(
                child: ListView.builder(
                  itemCount: dummyRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = dummyRecipes[index];
                    final recipeTitle = recipe['title'];

                    return GestureDetector(
                      onTap: () {
                        if (!recentRecipes.contains(recipeTitle)) {
                          recentRecipes.add(recipeTitle);
                        }

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

                              // 정보 영역
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

                                    // 아이콘 줄 (조회수 표시 추가 가능)
                                    Row(
                                      children: [
                                        const Icon(Icons.timer, size: 16),
                                        const SizedBox(width: 4),
                                        const Text('15분'),
                                        const SizedBox(width: 12),
                                        const Text('🔥 난이도 하'),
                                        const SizedBox(width: 12),
                                        const Text('🍽 1인분'),
                                        const Spacer(),
                                        // 조회수 표시 추가해도 됨 (옵션)
                                        Text('조회수 ${recipe['views']}'),
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
