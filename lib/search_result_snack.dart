// import 'package:capstone_trial_01/DB_helper.dart';
// import 'package:capstone_trial_01/breakfast_log.dart';
// import 'package:capstone_trial_01/utils/food_cache.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
//
// class SearchResultScreenSnack extends StatefulWidget {
//   final List<Map<String, dynamic>> results;
//   final Future<void> Function()? onScoreChanged;
//   const SearchResultScreenSnack({
//     super.key,
//     required this.results,
//     this.onScoreChanged,
//   });
//
//   @override
//   State<SearchResultScreenSnack> createState() =>
//       _SearchResultScreenSnackState();
// }
//
// class _SearchResultScreenSnackState extends State<SearchResultScreenSnack> {
//   String get selectedDateKey => DateFormat('yyyy.MM.dd').format(DateTime.now());
//   TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> filteredResults = [];
//   List<Map<String, dynamic>> foodList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     filteredResults = widget.results;
//     loadFoodList();
//   }
//
//   Future<void> loadFoodList() async {
//     foodList = await FoodCache.loadFoodList(context);
//     setState(() {});
//   }
//
//   void _searchFood(String query) {
//     setState(() {
//       filteredResults =
//           foodList
//               .where((food) => food['name'].toLowerCase().contains(query))
//               .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 뒤로가기 버튼
//             GestureDetector(
//               onTap: () => Navigator.pop(context),
//               child: Icon(Icons.arrow_back, color: Colors.black),
//             ),
//             SizedBox(height: 20),
//             // 검색창
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       onChanged: _searchFood,
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       decoration: InputDecoration(
//                         hintText: '음식명을 입력해주세요!',
//                         hintStyle: TextStyle(
//                           color: Colors.black, // 더 진한 회색
//                           fontWeight: FontWeight.w500, // 글자 두께 살짝 증가
//                           fontSize: 14,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.search, color: Colors.black),
//                     onPressed: () => _searchFood(_controller.text),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             // 검색 결과 리스트
//             Expanded(
//               child:
//                   filteredResults.isEmpty
//                       ? Center(
//                         child: Text(
//                           '검색 결과가 없습니다.',
//                           style: TextStyle(fontSize: 18, color: Colors.black54),
//                         ),
//                       )
//                       : ListView.builder(
//                         itemCount: filteredResults.length,
//                         itemBuilder: (context, index) {
//                           var food = filteredResults[index];
//                           return Container(
//                             margin: EdgeInsets.only(bottom: 16),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 20,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Color(0xFFEDFBE1), // 연녹색 배경
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 6,
//                                   offset: Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Stack(
//                               children: [
//                                 // 음식 이름 + 칼로리
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       food['name'],
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       '${food['kcal']} Kcal',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 // 오른쪽 상단 '추가' 버튼
//                                 Positioned(
//                                   right: 0,
//                                   top: 12,
//                                   child: GestureDetector(
//                                     onTap: () async {
//                                       await DBHelper.insertRecord({
//                                         'date': selectedDateKey,
//                                         'mealType': 'snack',
//                                         'name': food['name'],
//                                         'kcal': food['kcal'],
//                                         'water_g': food['water_g'],
//                                         'protein_g': food['protein_g'],
//                                         'fat_g': food['fat_g'],
//                                         'carbohydrate_g':
//                                             food['carbohydrate_g'],
//                                         'sugars_g': food['sugars_g'],
//                                         'fiber_g': food['fiber_g'],
//                                         'calcium_mg': food['calcium_mg'],
//                                         'sodium_mg': food['sodium_mg'],
//                                         'potassium_mg': food['potassium_mg'],
//                                         'vitamin_a_ug_RAE':
//                                             food['vitamin_a_ug_RAE'],
//                                         'retinol_ug': food['retinol_ug'],
//                                         'beta_carotene_ug':
//                                             food['beta_carotene_ug'],
//                                         'vitamin_c_mg': food['vitamin_c_mg'],
//                                         'vitamin_e_mg_ATE':
//                                             food['vitamin_e_mg_ATE'],
//                                         'selenium_ug': food['selenium_ug'],
//                                         'zinc_mg': food['zinc_mg'],
//                                         'copper_ug': food['copper_ug'],
//                                         'magnesium_mg': food['magnesium_mg'],
//                                         'manganese_mg': food['manganese_mg'],
//                                         'alpha_linolenic_acid_g':
//                                             food['alpha_linolenic_acid_g'],
//                                         'epa_mg': food['epa_mg'],
//                                         'omega3_fatty_acid_g':
//                                             food['omega3_fatty_acid_g'],
//                                         'threonine_mg': food['threonine_mg'],
//                                         'lysine_mg': food['lysine_mg'],
//                                         'leucine_mg': food['leucine_mg'],
//                                         'glutamic_acid_mg':
//                                             food['glutamic_acid_mg'],
//                                         'glycine_mg': food['glycine_mg'],
//                                         'folate_ug_DFE': food['folate_ug_DFE'],
//                                         'saturated_fat_g':
//                                             food['saturated_fat_g'],
//                                         'trans_fat_g': food['trans_fat_g'],
//                                         'trans_linoleic_acid_mg':
//                                             food['trans_linoleic_acid_mg'],
//                                         'trans_oleic_acid_mg':
//                                             food['trans_oleic_acid_mg'],
//                                         'trans_linolenic_acid_mg':
//                                             food['trans_linolenic_acid_mg'],
//                                         'glucose_g': food['glucose_g'],
//                                         'fructose_g': food['fructose_g'],
//                                         'cholesterol_mg':
//                                             food['cholesterol_mg'],
//                                         'lauric_acid_mg':
//                                             food['lauric_acid_mg'],
//                                         'myristic_acid_mg':
//                                             food['myristic_acid_mg'],
//                                         'palmitic_acid_mg':
//                                             food['palmitic_acid_mg'],
//                                         'stearic_acid_mg':
//                                             food['stearic_acid_mg'],
//                                         'behenic_acid_mg':
//                                             food['behenic_acid_mg'],
//                                       });
//                                       print('음식 추가됨!');
//                                       print(
//                                         'onScoreChanged: ${widget.onScoreChanged}',
//                                       );
//
//                                       if (widget.onScoreChanged != null) {
//                                         print('콜백 호출!');
//                                         await widget.onScoreChanged!();
//                                       }
//
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             '${food['name']} 추가되었습니다!',
//                                           ),
//                                           duration: Duration(seconds: 1),
//                                           behavior: SnackBarBehavior.floating,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               40,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//
//                                     child: SvgPicture.asset(
//                                       'assets/icon/plus_button.svg',
//                                       width: 28, // 아이콘 크기 조정 가능
//                                       height: 28,
//                                       colorFilter: ColorFilter.mode(
//                                         Colors.black,
//                                         BlendMode.srcIn,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//             ),
//
//             SizedBox(height: 10),
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   showGeneralDialog(
//                     context: context,
//                     barrierDismissible: true,
//                     barrierLabel: 'Dismiss',
//                     barrierColor: Colors.black.withOpacity(0.5),
//                     transitionDuration: Duration(milliseconds: 300),
//                     pageBuilder: (context, animation, secondaryAnimation) {
//                       return BreakfastLog(); // <- log 화면 위젯 이름
//                     },
//                   );
//                 },
//                 child: SvgPicture.asset(
//                   'assets/icon/record_button.svg',
//                   width: 60,
//                   height: 60,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:capstone_trial_01/DB_helper.dart';
import 'package:capstone_trial_01/breakfast_log.dart';
import 'package:capstone_trial_01/utils/food_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SearchResultScreenSnack extends StatefulWidget {
  final List<Map<String, dynamic>> results;
  final Future<void> Function()? onScoreChanged;
  const SearchResultScreenSnack({
    super.key,
    required this.results,
    this.onScoreChanged,
  });

  @override
  State<SearchResultScreenSnack> createState() =>
      _SearchResultScreenSnackState();
}

class _SearchResultScreenSnackState extends State<SearchResultScreenSnack> {
  String get selectedDateKey => DateFormat('yyyy.MM.dd').format(DateTime.now());
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> filteredResults = [];
  List<Map<String, dynamic>> foodList = [];

  @override
  void initState() {
    super.initState();
    filteredResults = widget.results;
    loadFoodList();
  }

  Future<void> loadFoodList() async {
    foodList = await FoodCache.loadFoodList(context);
    setState(() {});
  }

  void _searchFood(String query) {
    setState(() {
      filteredResults =
          foodList
              .where((food) => food['name'].toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgPurple = Color(0xFF8F80F9);
    final bgMint = Color(0xFF5ED593);

    return Scaffold(
      backgroundColor: Color(0xFFF9F8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 바
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back, color: bgPurple, size: 26),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '음식 검색',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: bgPurple,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              // 검색창
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      bgPurple.withOpacity(0.11),
                      bgMint.withOpacity(0.11),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: _searchFood,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '음식명을 입력해주세요!',
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: bgPurple, size: 24),
                      onPressed: () => _searchFood(_controller.text),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // 검색 결과 리스트
              Expanded(
                child:
                    filteredResults.isEmpty
                        ? Center(
                          child: Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black38,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: filteredResults.length,
                          itemBuilder: (context, index) {
                            var food = filteredResults[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    bgPurple.withOpacity(0.13),
                                    bgMint.withOpacity(0.10),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 7,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 22,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // 아이콘 or 동그라미
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [bgPurple, bgMint],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/icon/snack.svg', // 간식용 아이콘
                                              width: 22,
                                              height: 22,
                                              colorFilter: ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        // 음식 이름 및 칼로리
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                food['name'],
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                '${food['kcal']} Kcal',
                                                style: TextStyle(
                                                  fontSize: 13.5,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // +버튼
                                        GestureDetector(
                                          onTap: () async {
                                            await DBHelper.insertRecord({
                                              'date': selectedDateKey,
                                              'mealType': 'snack',
                                              // ...이하 생략! (DB 관련 로직, 그대로 유지)
                                              ...food,
                                            });
                                            if (widget.onScoreChanged != null)
                                              await widget.onScoreChanged!();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${food['name']} 추가되었습니다!',
                                                ),
                                                duration: Duration(seconds: 1),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [bgPurple, bgMint],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
              // 플로팅 버튼
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Dismiss',
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 300),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return BreakfastLog();
                      },
                    );
                  },
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [bgPurple, bgMint],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: bgPurple.withOpacity(0.20),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icon/record_button.svg',
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
