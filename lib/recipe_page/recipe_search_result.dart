import 'package:flutter/material.dart';
import 'package:shim/DB/db_record.dart';
import 'package:shim/DB/recipe/db_recent_seen_recipe.dart';
import 'package:shim/DB/recipe/db_recipe.dart';
import 'package:shim/recipe_page/recipe_detail_page.dart';

class RecipeSearchResultPage extends StatefulWidget {
  final String query;
  final Future<void> Function()? onFoodChanged;

  const RecipeSearchResultPage({required this.query, this.onFoodChanged});

  @override
  State<RecipeSearchResultPage> createState() => _RecipeSearchResultPageState();
}

class _RecipeSearchResultPageState extends State<RecipeSearchResultPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  String currentQuery = '';

  String sortOrder = 'latest';

  final Color bgPurple = const Color(0xFF8F80F9);
  final Color bgMint = const Color(0xFF5ED593);

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    currentQuery = widget.query;
    _onSearch(currentQuery);
  }

  void _onSearch(String query, {String order = 'latest'}) async {
    setState(() {
      isLoading = true;
      currentQuery = query;
    });
    try {
      final results = await searchRecipes(query, order: order);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _sortResults(
    List<Map<String, dynamic>> results,
    String order,
  ) {
    final sorted = List<Map<String, dynamic>>.from(results);
    if (order == 'latest') {
      sorted.sort(
        (a, b) => (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? ''),
      );
    } else if (order == 'views') {
      sorted.sort((a, b) => (b['views'] ?? 0).compareTo(a['views'] ?? 0));
    }
    return sorted;
  }

  void _onSortChange(String newOrder) {
    if (sortOrder == newOrder) return;
    setState(() {
      sortOrder = newOrder;
      searchResults = _sortResults(searchResults, sortOrder);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '레시피 검색 결과',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.7,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
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
                        controller: _searchController,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: '검색어 또는 키워드를 입력하세요',
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
                        onSubmitted: (query) {
                          if (query.trim().isEmpty) return;
                          _onSearch(query);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: () {
                          final query = _searchController.text.trim();
                          if (query.isEmpty) return;
                          _onSearch(query);
                        },
                        child: Icon(Icons.search, color: bgPurple, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _SortButton(
                    text: "최신순",
                    selected: sortOrder == 'latest',
                    color: bgPurple,
                    onTap: () {
                      if (sortOrder != 'latest') {
                        setState(() => sortOrder = 'latest');
                        _onSearch(currentQuery, order: 'latest');
                      }
                    },
                  ),
                  SizedBox(width: 2),
                  Text(
                    '|',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 2),
                  _SortButton(
                    text: "조회순",
                    selected: sortOrder == 'views',
                    color: bgPurple,
                    onTap: () {
                      if (sortOrder != 'views') {
                        setState(() => sortOrder = 'views');
                        _onSearch(currentQuery, order: 'views');
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                "'${currentQuery}' 검색 결과",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.73),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : searchResults.isNotEmpty
                      ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchResults.length,
                        itemBuilder:
                            (context, idx) => GestureDetector(
                              onTap: () async {
                                final recipe = searchResults[idx];
                                await increaseRecipeView(recipe['_id']);
                                await addRecentRecipe(recipe['_id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => RecipeDetailPage(recipe: recipe),
                                  ),
                                );
                              },
                              child: RecipeCard(
                                recipe: searchResults[idx],
                                onFoodChanged: widget.onFoodChanged,
                              ),
                            ),
                      )
                      : Center(
                        child: Text(
                          "검색 결과가 없습니다.",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String text;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _SortButton({
    required this.text,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: selected ? color : Colors.grey[600],
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 15,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final Future<void> Function()? onFoodChanged;

  const RecipeCard({Key? key, required this.recipe, this.onFoodChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgPurple = Color(0xFF8F80F9);
    final bgMint = Color(0xFF5ED593);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bgPurple.withOpacity(0.11), bgMint.withOpacity(0.11)],
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
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe['imageUrl'] ?? '',
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 85,
                            height: 85,
                            color: Colors.grey[300],
                          ),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['name'] ?? '이름 없음',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(height: 3),
                        if (recipe['keywords'] != null)
                          Text(
                            (recipe['keywords'] as List)
                                .map((e) => '#$e')
                                .join('  '),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        if (recipe['desc'] != null) ...[
                          SizedBox(height: 4),
                          Text(
                            recipe['desc'],
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.black.withOpacity(0.7),
                              fontFamily: 'Pretendard',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 14, color: Colors.black54),
                            SizedBox(width: 4),
                            Text(
                              '${recipe['time'] ?? '?'}분',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '🔥 난이도 ${recipe['level'] ?? '?'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '👤 ${recipe['serving'] ?? '?'}인분',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
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
          ),
          Positioned(
            top: 10,
            right: 12,
            child: GestureDetector(
              onTap: () async {
                final mealType = await showDialog<String>(
                  context: context,
                  builder:
                      (context) => SimpleDialog(
                        title: Text('어느 \ 끼니에 추가할까요?'),
                        children:
                            ['breakfast', 'lunch', 'dinner', 'snack'].map((
                              meal,
                            ) {
                              return SimpleDialogOption(
                                child: Text(_getKoreanMealName(meal)),
                                onPressed: () => Navigator.pop(context, meal),
                              );
                            }).toList(),
                      ),
                );

                if (mealType == null) return;

                await insertRecord({
                  'mealType': mealType,
                  'date': todayStr(),
                  'name': recipe['name'],
                  'score': recipe['score'],
                });

                if (onFoodChanged != null) {
                  print('📣 RecipeCard에서 onFoodChanged 호출!');
                  await onFoodChanged!();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${recipe['name']}이(가) $mealType에 추가되었습니다!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [bgPurple, bgMint],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _getKoreanMealName(String eng) {
  switch (eng) {
    case 'breakfast':
      return '아침';
    case 'lunch':
      return '점심';
    case 'dinner':
      return '저녁';
    case 'snack':
      return '간식';
    default:
      return eng;
  }
}

String todayStr() {
  final now = DateTime.now();
  return '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
}
