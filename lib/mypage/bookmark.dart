import 'package:flutter/material.dart';
import 'package:shim/DB/mypage/db_bookmark1.dart';
import 'package:shim/mypage/appbar.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchBookmarkRecipes();
  }

  Future<void> fetchBookmarkRecipes() async {
    final data = await fetchBookmarkRecipesFromDB();
    if (data != null) {
      setState(() {
        recipes = data;
      });
    }
  }

  Future<void> deleteBookmark(int recipeId) async {
    final success = await deleteBookmarkFromDB(recipeId);
    if (success) {
      setState(() {
        recipes.removeWhere((r) => r['recipeId'] == recipeId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '북마크'),
      backgroundColor: Colors.white,
      body:
          recipes.isEmpty
              ? buildEmptyBookmarkView(screenHeight, screenWidth, context)
              : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return buildRecipeCard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    imagePath: recipe['imageUrl'],
                    title: recipe['title'],
                    tags: recipe['tags'].map((t) => '#$t').join('  '),
                    description: recipe['description'],
                    time: recipe['timeRequired'],
                    difficulty: recipe['difficulty'],
                    portion: recipe['serving'],
                    onDelete: () => deleteBookmark(recipe['recipeId']),
                  );
                },
              ),
    );
  }

  Widget buildRecipeCard({
    required double screenHeight,
    required double screenWidth,
    required String imagePath,
    required String title,
    required String tags,
    required String description,
    required String time,
    required String difficulty,
    required String portion,
    required VoidCallback onDelete,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.012,
            horizontal: screenWidth * 0.04,
          ),
          padding: EdgeInsets.all(screenWidth * 0.025),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagePath,
                  width: screenWidth * 0.23,
                  height: screenWidth * 0.23,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      tags,
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.008),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.black,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          '🔥 난이도 $difficulty',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          '🍽️ $portion',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: screenHeight * 0.005,
          right: screenWidth * 0.045,
          child: IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

Widget buildEmptyBookmarkView(
  double screenHeight,
  double screenWidth,
  BuildContext context,
) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 이미지 크기: 높이의 약 28%, 너비 60%
        Image.asset(
          'assets/icon/search_turtle.png',
          width: screenWidth * 0.6,
          height: screenHeight * 0.28,
          fit: BoxFit.contain,
        ),

        SizedBox(height: screenHeight * 0.04), // 텍스트 위 간격 (약 40pt)

        Text(
          '아직 등록된 레시피가 없습니다!',
          style: TextStyle(
            fontSize: screenWidth * 0.045, // 약 18pt 기준
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        SizedBox(height: screenHeight * 0.035), // 버튼 위 간격 (약 32pt)

        SizedBox(
          width: screenWidth * 0.65, // 버튼 너비 (약 280pt)
          height: screenHeight * 0.06, // 버튼 높이 (약 56pt)
          child: ElevatedButton(
            onPressed: () {
              //Navigator.pushNamed(context, '/recipes'); //💙향후 연결
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF80), // 민트색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              '레시피 찾기',
              style: TextStyle(
                fontSize: screenWidth * 0.042, // 약 16pt
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
