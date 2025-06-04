import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shim/DB/db_record.dart';
import 'package:shim/main_page/breakfast_log.dart';
import 'package:shim/utils/food_cache.dart';

class SearchResultScreenBf extends StatefulWidget {
  final List<Map<String, dynamic>> results;
  final Future<void> Function()? onScoreChanged;
  const SearchResultScreenBf({
    super.key,
    required this.results,
    this.onScoreChanged,
  });

  @override
  State<SearchResultScreenBf> createState() => _SearchResultScreenBfState();
}

class _SearchResultScreenBfState extends State<SearchResultScreenBf> {
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
                                              'assets/icon/breakfast.svg', // 원하는 svg (혹은 기본식 아이콘)
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
                                            await insertRecord({
                                              'date': selectedDateKey,
                                              'mealType': 'breakfast',
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
