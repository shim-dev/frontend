import 'package:flutter/material.dart';
import 'package:capstone_trial_01/appbar.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: '북마크'),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: screenHeight * 0.015), // 상단 여백
          buildRecipeCard(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            imagePath: 'assets/food_sample/tofu_padthai.png',
            title: '두부면 팟타이',
            tags: '#식물성단백질  #두부면  #팟타이',
            description: '탄수화물 부담 없이 즐기는 저탄고단 태국식 볶음면',
            time: '15분',
            difficulty: '하',
            portion: '1인분',
          ),
          buildRecipeCard(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            imagePath: 'assets/food_sample/tofu_noodles.png',
            title: '초간단 두부면 레시피',
            tags: '#식물성단백질  #두부면  #5분요리',
            description: '초간단 들기름 두부면 레시피',
            time: '10분',
            difficulty: '하',
            portion: '1인분',
          ),
        ],
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
  }) {
    return Container(
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
            color: Colors.black.withOpacity(0.25), // 25% 투명도
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
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
                    color : Colors.black,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
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
                    const Icon(Icons.schedule, size: 16, color: Colors.black),
                    SizedBox(width: screenWidth * 0.01),
                    Text(time, style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.black)),
                    SizedBox(width: screenWidth * 0.03),
                    Text("🔥 난이도 $difficulty",
                        style: TextStyle(fontSize: screenWidth * 0.03,color: Colors.black)),
                    SizedBox(width: screenWidth * 0.03),
                    Text("🍽️ $portion",
                        style: TextStyle(fontSize: screenWidth * 0.03,color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
