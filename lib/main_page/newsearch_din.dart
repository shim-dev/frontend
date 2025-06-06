import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shim/DB/db_record.dart';
import 'package:shim/utils/food_cache.dart';

class SearchAddScreenDin extends StatefulWidget {
  final Future<void> Function()? onUpdated;
  final Future<void> Function()? onFoodChanged;
  final DateTime selectedDate;
  final String mealType;

  const SearchAddScreenDin({
    super.key,
    required this.selectedDate,
    required this.mealType,
    this.onUpdated,
    this.onFoodChanged,
  });

  @override
  State<SearchAddScreenDin> createState() => _SearchAddScreenDinState();
}

class _SearchAddScreenDinState extends State<SearchAddScreenDin> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> foodList = [];
  List<Map<String, dynamic>> filteredResults = [];
  bool _hasAdded = false;

  String get selectedDateKey =>
      DateFormat('yyyy.MM.dd').format(widget.selectedDate);

  @override
  void initState() {
    super.initState();
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
              .where(
                (food) =>
                    food['name'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  Future<void> _addFoodToDB(Map<String, dynamic> food) async {
    await insertRecord({
      'date': selectedDateKey,
      'mealType': widget.mealType,
      ...food,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food['name']} 추가되었습니다!'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
    );
    setState(() => _hasAdded = true);
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
              // 상단바
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, _hasAdded),
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
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          hintText: '음식명을 입력해주세요!',
                          hintStyle: TextStyle(
                            color: Colors.black54,
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
                        ? const Center(
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
                            final food = filteredResults[index];
                            // 식사타입별 svg 경로
                            String iconPath = 'assets/icon/breakfast.svg';
                            if (widget.mealType == 'lunch')
                              iconPath = 'assets/icon/lunch.svg';
                            else if (widget.mealType == 'dinner')
                              iconPath = 'assets/icon/dinner.svg';
                            else if (widget.mealType == 'snack')
                              iconPath = 'assets/icon/snack.svg';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 22,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 식사타입별 아이콘
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
                                          iconPath,
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
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${food['kcal']} Kcal',
                                            style: const TextStyle(
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
                                        await _addFoodToDB(food);
                                        if (widget.onUpdated != null) {
                                          await widget.onUpdated!();
                                        }
                                        if (widget.onFoodChanged != null) {
                                          await widget.onFoodChanged!();
                                        }
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
                                        child: const Center(
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
