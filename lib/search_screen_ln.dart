// import 'dart:ui';
//
// import 'package:capstone_trial_01/utils/food_cache.dart';
// import 'package:dio/dio.dart'; // 카메라 기능
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart'; // 카메라 기능
//
// import 'search_result_ln.dart';
//
// final TextEditingController _controller = TextEditingController();
//
// class SearchScreenLn extends StatefulWidget {
//   final Future<void> Function()? onScoreChanged;
//   const SearchScreenLn({super.key, this.onScoreChanged});
//
//   @override
//   State<SearchScreenLn> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreenLn> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> foodList = [];
//   List<Map<String, dynamic>> _searchResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadFoodList();
//   }
//
//   // 카메라 파트 시작 //
//
//   // 카메라 키기
//   Future<XFile?> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//     return image;
//   }
//
//   // 카메라에서 찍은 거 서버로 전송
//   Future<String?> sendImageToServer(String imagePath) async {
//     print('📷 서버로 보낼 파일 경로: $imagePath');
//     final dio = Dio();
//     final formData = FormData.fromMap({
//       'image': await MultipartFile.fromFile(imagePath, filename: 'food.jpg'),
//     });
//     try {
//       final response = await dio.post(
//         'http://59.5.184.5:5000/detect',
//         data: formData,
//       );
//       print('🔗 서버 응답: ${response.statusCode}');
//       print('🔗 서버 데이터: ${response.data}');
//       if (response.statusCode == 200) {
//         final resultList = response.data;
//         if (resultList is List && resultList.isNotEmpty) {
//           print('🍽️ 서버에서 받은 label: ${resultList[0]['label']}');
//           return resultList[0]['label'];
//         }
//       }
//     } catch (e, stack) {
//       print('🚨 서버 통신 에러: $e');
//       print('🚨 Dio error stack: $stack');
//     }
//     return null;
//   }
//
//   // 인식된 영어 라벨링 값 -> 한국어로 변환
//   final Map<String, String> labelToKorean = {
//     'tteokbokki': '떡볶이',
//     'pizza': '피자',
//     // ... 필요한 만큼 추가
//   };
//
//   String getKoreanLabel(String label) {
//     return labelToKorean[label] ?? label; // 없으면 영문 그대로 반환
//   }
//
//   void onTakePictureAndSearch(BuildContext context) async {
//     final image = await pickImage();
//     print('📸 pickImage 결과: $image');
//     if (image == null) return;
//
//     final engLabel = await sendImageToServer(image.path);
//     print('🌏 서버에서 받은 engLabel: $engLabel');
//     if (engLabel == null) {
//       print('❌ 서버에서 라벨을 못받음!');
//       return;
//     }
//
//     final korLabel = getKoreanLabel(engLabel);
//     print('🇰🇷 한글 라벨: $korLabel');
//
//     // 여기서 _controller.text 안써도 됨!
//     // _searchFood 함수 복붙 (중복 코드 허용)
//     String query = korLabel.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SearchResultScreenLn(
//               results: results,
//               onScoreChanged: widget.onScoreChanged,
//             ),
//       ),
//     );
//
//     if (result == true) {
//       setState(() {}); // 화면 갱신(점수도 다시 계산됨)
//       if (widget.onScoreChanged != null) {
//         await widget.onScoreChanged!(); // 점수 갱신 함수도 실행
//       }
//     }
//   }
//
//   // 카메라 파트 마무리//
//
//   // 사진 파트 시작 //
//   Future<XFile?> pickImageFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     return image;
//   }
//
//   void onPickImageFromGalleryAndSearch(BuildContext context) async {
//     final image = await pickImageFromGallery();
//     print('🖼️ pickImageFromGallery 결과: $image');
//     if (image == null) return;
//
//     final engLabel = await sendImageToServer(image.path);
//     print('🌏 서버에서 받은 engLabel: $engLabel');
//     if (engLabel == null) {
//       print('❌ 서버에서 라벨을 못받음!');
//       return;
//     }
//
//     final korLabel = getKoreanLabel(engLabel);
//     print('🇰🇷 한글 라벨: $korLabel');
//
//     String query = korLabel.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SearchResultScreenLn(
//               results: results,
//               onScoreChanged: widget.onScoreChanged,
//             ),
//       ),
//     );
//
//     if (result == true) {
//       setState(() {}); // 화면 갱신
//       if (widget.onScoreChanged != null) {
//         await widget.onScoreChanged!();
//       }
//     }
//   }
//
//   // 사진 파트 마무리 //
//   void _updateSearchResults(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }
//
//     setState(() {
//       _searchResults =
//           foodList
//               .where(
//                 (food) =>
//                     food['name'].toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();
//     });
//   }
//
//   Future<void> loadFoodList() async {
//     foodList = await FoodCache.loadFoodList(context);
//     setState(() {});
//   }
//
//   void _searchFood(BuildContext context) {
//     String query = _controller.text.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SearchResultScreenLn(results: results),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(), // 바깥 누르면 닫힘!
//               child: ImageFiltered(
//                 imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(color: Color.fromRGBO(0, 0, 0, 0.2)),
//               ),
//             ),
//           ),
//           // 초록색 팝업 박스
//           Center(
//             child: Container(
//               width: 390,
//               height: 700,
//               clipBehavior: Clip.antiAlias,
//               decoration: ShapeDecoration(
//                 color: const Color(0xFFFFFFFF),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 shadows: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 20,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Stack(
//                 children: [
//                   // 뒤로가기 버튼
//                   Positioned(
//                     left: 24,
//                     top: 46,
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: SvgPicture.asset(
//                         'assets/icon/arrow_back.svg',
//                         width: 32,
//                         height: 32,
//                       ),
//                     ),
//                   ),
//
//                   // 제목
//                   Positioned(
//                     left: 126,
//                     top: 46,
//                     child: Text(
//                       '🔍 검색하기',
//                       style: TextStyle(
//                         color: Color(0xFF1A1D1F),
//                         fontSize: 24,
//                         fontFamily: 'Pretendard',
//                         fontWeight: FontWeight.w700,
//                         height: 1.33,
//                       ),
//                     ),
//                   ),
//
//                   // 회색 박스
//                   Positioned(
//                     left: 44,
//                     top: 136,
//                     child: Container(
//                       width: 302,
//                       height: 256,
//                       decoration: ShapeDecoration(
//                         color: Color(0xFFD9D9D9),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // 초록색 Search 버튼
//                   Positioned(
//                     left: 44,
//                     top: 412,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () => onTakePictureAndSearch(context),
//                           child: Container(
//                             width: 140,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             decoration: ShapeDecoration(
//                               color: const Color(0xCC0A8356),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/icon/Camera.svg', // 아이콘 경로
//                                   width: 20,
//                                   height: 20,
//                                   colorFilter: const ColorFilter.mode(
//                                     Colors.white,
//                                     BlendMode.srcIn,
//                                   ), // 색상 입히기 (선택)
//                                 ),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   '촬영하기',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontFamily: 'Pretendard',
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 22),
//                         GestureDetector(
//                           onTap: () => onPickImageFromGalleryAndSearch(context),
//                           child: Container(
//                             width: 140,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             decoration: ShapeDecoration(
//                               color: const Color(0xCC0A8356),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/icon/picture.svg', // 아이콘 경로
//                                   width: 20,
//                                   height: 20,
//                                   colorFilter: const ColorFilter.mode(
//                                     Colors.white,
//                                     BlendMode.srcIn,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   '불러오기',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontFamily: 'Pretendard',
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // "직접 입력하기" 텍스트
//                   Positioned(
//                     left: 112,
//                     top: 541,
//                     child: SizedBox(
//                       width: 339,
//                       child: Text(
//                         '✏️ 직접 입력하기',
//                         style: TextStyle(
//                           color: Color(0xFF1A1D1F),
//                           fontSize: 24,
//                           fontFamily: 'Pretendard',
//                           fontWeight: FontWeight.w700,
//                           height: 1.33,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // 검색 텍스트필드
//                   Positioned(
//                     left: 24,
//                     top: 600,
//                     child: Container(
//                       width: 342,
//                       decoration: BoxDecoration(
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 10,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: TextField(
//                         controller: _controller,
//                         onChanged: _updateSearchResults,
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 14,
//                           fontFamily: 'Pretendard',
//                           fontWeight: FontWeight.w400,
//                         ),
//                         decoration: InputDecoration(
//                           hintText: '음식명을 입력해주세요!',
//                           hintStyle: TextStyle(
//                             color: Color(0xFF333333),
//                             fontSize: 14,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w400,
//                             height: 1.29,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(color: Color(0xFFE5E7EA)),
//                           ),
//                           suffixIcon: GestureDetector(
//                             onTap: () => _searchFood(context),
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 12),
//                               child: SvgPicture.asset(
//                                 'assets/icon/search.svg',
//                                 width: 20,
//                                 height: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   // ✅ 실시간 검색 결과 리스트
//                   if (_searchResults.isNotEmpty)
//                     Positioned(
//                       left: 24,
//                       bottom: 120,
//                       child: Container(
//                         width: 342,
//                         constraints: BoxConstraints(
//                           maxHeight: 240, // 최대 높이 4개 정도 (60 * 4 = 240)
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Color(0xFFE5E7EA)),
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 6,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _searchResults.length,
//                           itemBuilder: (context, index) {
//                             final food = _searchResults[index];
//                             return ListTile(
//                               title: Text(
//                                 food['name'],
//                                 style: TextStyle(
//                                   fontFamily: 'Pretendard',
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder:
//                                         (context) => SearchResultScreenLn(
//                                           results: [food],
//                                           onScoreChanged: widget.onScoreChanged,
//                                         ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:ui';
//
// import 'package:capstone_trial_01/utils/food_cache.dart';
// import 'package:dio/dio.dart'; // 카메라 기능
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart'; // 카메라 기능
//
// import 'search_result_ln.dart';
//
// final TextEditingController _controller = TextEditingController();
//
// class SearchScreenLn extends StatefulWidget {
//   final Future<void> Function()? onScoreChanged;
//   const SearchScreenLn({super.key, this.onScoreChanged});
//
//   @override
//   State<SearchScreenLn> createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreenLn> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> foodList = [];
//   List<Map<String, dynamic>> _searchResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     loadFoodList();
//   }
//
//   // 카메라 파트 시작 //
//
//   // 카메라 키기
//   Future<XFile?> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//     return image;
//   }
//
//   // 카메라에서 찍은 거 서버로 전송
//   Future<String?> sendImageToServer(String imagePath) async {
//     print('📷 서버로 보낼 파일 경로: $imagePath');
//     final dio = Dio();
//     final formData = FormData.fromMap({
//       'image': await MultipartFile.fromFile(imagePath, filename: 'food.jpg'),
//     });
//     try {
//       final response = await dio.post(
//         'http://59.5.184.5:5000/detect',
//         data: formData,
//       );
//       print('🔗 서버 응답: ${response.statusCode}');
//       print('🔗 서버 데이터: ${response.data}');
//       if (response.statusCode == 200) {
//         final resultList = response.data;
//         if (resultList is List && resultList.isNotEmpty) {
//           print('🍽️ 서버에서 받은 label: ${resultList[0]['label']}');
//           return resultList[0]['label'];
//         }
//       }
//     } catch (e, stack) {
//       print('🚨 서버 통신 에러: $e');
//       print('🚨 Dio error stack: $stack');
//     }
//     return null;
//   }
//
//   // 인식된 영어 라벨링 값 -> 한국어로 변환
//   final Map<String, String> labelToKorean = {
//     'tteokbokki': '떡볶이',
//     'pizza': '피자',
//     // ... 필요한 만큼 추가
//   };
//
//   String getKoreanLabel(String label) {
//     return labelToKorean[label] ?? label; // 없으면 영문 그대로 반환
//   }
//
//   void onTakePictureAndSearch(BuildContext context) async {
//     final image = await pickImage();
//     print('📸 pickImage 결과: $image');
//     if (image == null) return;
//
//     final engLabel = await sendImageToServer(image.path);
//     print('🌏 서버에서 받은 engLabel: $engLabel');
//     if (engLabel == null) {
//       print('❌ 서버에서 라벨을 못받음!');
//       return;
//     }
//
//     final korLabel = getKoreanLabel(engLabel);
//     print('🇰🇷 한글 라벨: $korLabel');
//
//     // 여기서 _controller.text 안써도 됨!
//     // _searchFood 함수 복붙 (중복 코드 허용)
//     String query = korLabel.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SearchResultScreenLn(
//               results: results,
//               onScoreChanged: widget.onScoreChanged,
//             ),
//       ),
//     );
//
//     if (result == true) {
//       setState(() {}); // 화면 갱신(점수도 다시 계산됨)
//       if (widget.onScoreChanged != null) {
//         await widget.onScoreChanged!(); // 점수 갱신 함수도 실행
//       }
//     }
//   }
//
//   // 카메라 파트 마무리//
//
//   // 사진 파트 시작 //
//   Future<XFile?> pickImageFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     return image;
//   }
//
//   void onPickImageFromGalleryAndSearch(BuildContext context) async {
//     final image = await pickImageFromGallery();
//     print('🖼️ pickImageFromGallery 결과: $image');
//     if (image == null) return;
//
//     final engLabel = await sendImageToServer(image.path);
//     print('🌏 서버에서 받은 engLabel: $engLabel');
//     if (engLabel == null) {
//       print('❌ 서버에서 라벨을 못받음!');
//       return;
//     }
//
//     final korLabel = getKoreanLabel(engLabel);
//     print('🇰🇷 한글 라벨: $korLabel');
//
//     String query = korLabel.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SearchResultScreenLn(
//               results: results,
//               onScoreChanged: widget.onScoreChanged,
//             ),
//       ),
//     );
//
//     if (result == true) {
//       setState(() {}); // 화면 갱신
//       if (widget.onScoreChanged != null) {
//         await widget.onScoreChanged!();
//       }
//     }
//   }
//
//   // 사진 파트 마무리 //
//   void _updateSearchResults(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }
//
//     setState(() {
//       _searchResults =
//           foodList
//               .where(
//                 (food) =>
//                     food['name'].toLowerCase().contains(query.toLowerCase()),
//               )
//               .toList();
//     });
//   }
//
//   Future<void> loadFoodList() async {
//     foodList = await FoodCache.loadFoodList(context);
//     setState(() {});
//   }
//
//   void _searchFood(BuildContext context) {
//     String query = _controller.text.trim();
//     if (query.isEmpty) return;
//
//     List<Map<String, dynamic>> results =
//         foodList.where((food) => food['name'].contains(query)).toList();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SearchResultScreenLn(results: results),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(), // 바깥 누르면 닫힘!
//               child: ImageFiltered(
//                 imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(color: Color.fromRGBO(0, 0, 0, 0.2)),
//               ),
//             ),
//           ),
//           // 초록색 팝업 박스
//           Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SizedBox(
//                 width: 390,
//                 height: 700, // 원하는 크기
//                 child: Container(
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: const Color(0xFFFFFFFF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     shadows: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 20,
//                         offset: Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       // 뒤로가기 버튼
//                       Positioned(
//                         left: 24,
//                         top: 46,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: SvgPicture.asset(
//                             'assets/icon/arrow_back.svg',
//                             width: 32,
//                             height: 32,
//                           ),
//                         ),
//                       ),
//
//                       // 제목
//                       Positioned(
//                         left: 126,
//                         top: 46,
//                         child: Text(
//                           '🔍 검색하기',
//                           style: TextStyle(
//                             color: Color(0xFF1A1D1F),
//                             fontSize: 24,
//                             fontFamily: 'Pretendard',
//                             fontWeight: FontWeight.w700,
//                             height: 1.33,
//                           ),
//                         ),
//                       ),
//
//                       // 회색 박스
//                       Positioned(
//                         left: 44,
//                         top: 136,
//                         child: Container(
//                           width: 302,
//                           height: 256,
//                           decoration: ShapeDecoration(
//                             color: Color(0xFFD9D9D9),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // 초록색 Search 버튼
//                       Positioned(
//                         left: 44,
//                         top: 412,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () => onTakePictureAndSearch(context),
//                               child: Container(
//                                 width: 140,
//                                 height: 50,
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: ShapeDecoration(
//                                   color: const Color(0xCC0A8356),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                       'assets/icon/Camera.svg', // 아이콘 경로
//                                       width: 20,
//                                       height: 20,
//                                       colorFilter: const ColorFilter.mode(
//                                         Colors.white,
//                                         BlendMode.srcIn,
//                                       ), // 색상 입히기 (선택)
//                                     ),
//                                     const SizedBox(width: 8),
//                                     const Text(
//                                       '촬영하기',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontFamily: 'Pretendard',
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 22),
//                             GestureDetector(
//                               onTap:
//                                   () =>
//                                       onPickImageFromGalleryAndSearch(context),
//                               child: Container(
//                                 width: 140,
//                                 height: 50,
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: ShapeDecoration(
//                                   color: const Color(0xCC0A8356),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                       'assets/icon/picture.svg', // 아이콘 경로
//                                       width: 20,
//                                       height: 20,
//                                       colorFilter: const ColorFilter.mode(
//                                         Colors.white,
//                                         BlendMode.srcIn,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     const Text(
//                                       '불러오기',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontFamily: 'Pretendard',
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // "직접 입력하기" 텍스트
//                       Positioned(
//                         left: 112,
//                         top: 541,
//                         child: SizedBox(
//                           width: 339,
//                           child: Text(
//                             '✏️ 직접 입력하기',
//                             style: TextStyle(
//                               color: Color(0xFF1A1D1F),
//                               fontSize: 24,
//                               fontFamily: 'Pretendard',
//                               fontWeight: FontWeight.w700,
//                               height: 1.33,
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // 검색 텍스트필드
//                       Positioned(
//                         left: 24,
//                         top: 600,
//                         child: Container(
//                           width: 342,
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 spreadRadius: 2,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _controller,
//                             onChanged: _updateSearchResults,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 14,
//                               fontFamily: 'Pretendard',
//                               fontWeight: FontWeight.w400,
//                             ),
//                             decoration: InputDecoration(
//                               hintText: '음식명을 입력해주세요!',
//                               hintStyle: TextStyle(
//                                 color: Color(0xFF333333),
//                                 fontSize: 14,
//                                 fontFamily: 'Pretendard',
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.29,
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 12,
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                                 borderSide: BorderSide(
//                                   color: Color(0xFFE5E7EA),
//                                 ),
//                               ),
//                               suffixIcon: GestureDetector(
//                                 onTap: () => _searchFood(context),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(right: 12),
//                                   child: SvgPicture.asset(
//                                     'assets/icon/search.svg',
//                                     width: 20,
//                                     height: 20,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       // ✅ 실시간 검색 결과 리스트
//                       if (_searchResults.isNotEmpty)
//                         Positioned(
//                           left: 24,
//                           bottom: 120,
//                           child: Container(
//                             width: 342,
//                             constraints: BoxConstraints(
//                               maxHeight: 240, // 최대 높이 4개 정도 (60 * 4 = 240)
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Color(0xFFE5E7EA)),
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 6,
//                                   offset: Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: _searchResults.length,
//                               itemBuilder: (context, index) {
//                                 final food = _searchResults[index];
//                                 return ListTile(
//                                   title: Text(
//                                     food['name'],
//                                     style: TextStyle(
//                                       fontFamily: 'Pretendard',
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder:
//                                             (context) => SearchResultScreenLn(
//                                               results: [food],
//                                               onScoreChanged:
//                                                   widget.onScoreChanged,
//                                             ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                     ],
//                     // 기존 Stack 코드 그대로
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:capstone_trial_01/utils/food_cache.dart';
import 'package:dio/dio.dart'; // 카메라 기능
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart'; // 카메라 기능

import 'search_result_ln.dart';

final TextEditingController _controller = TextEditingController();

class SearchScreenLn extends StatefulWidget {
  final Future<void> Function()? onScoreChanged;
  const SearchScreenLn({super.key, this.onScoreChanged});

  @override
  State<SearchScreenLn> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreenLn> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> foodList = [];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    loadFoodList();
  }

  // 카메라 파트 시작 //

  // 카메라 키기
  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image;
  }

  // 카메라에서 찍은 거 서버로 전송
  Future<List<String>?> sendImageToServer(String imagePath) async {
    print('📷 서버로 보낼 파일 경로: $imagePath');
    final dio = Dio();
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imagePath, filename: 'food.jpg'),
    });
    try {
      final response = await dio.post(
        'http://59.5.184.5:5000/detect',
        data: formData,
      );
      print('🔗 서버 응답: ${response.statusCode}');
      print('🔗 서버 데이터: ${response.data}');
      if (response.statusCode == 200) {
        final resultList = response.data;
        if (resultList is List && resultList.isNotEmpty) {
          final labels =
              resultList
                  .map<String>((item) => item['label'].toString())
                  .toList();
          print('🍽️ 서버에서 받은 모든 labels: $labels');
          return labels;
        }
      }
    } catch (e, stack) {
      print('🚨 서버 통신 에러: $e');
      print('🚨 Dio error stack: $stack');
    }
    return null;
  }

  // 인식된 영어 라벨링 값 -> 한국어로 변환
  final Map<String, String> labelToKorean = {
    'tteokbokki': '떡볶이',
    'pizza': '피자',
    'onigiri': '주먹밥',
    'popcorn': '팝콘',
    'kimchi_stew': '김치찌개',
    'pan_cake': '팬케이크',
    'coffee_ice': '아메리카노',
    'macaroon': '마카롱',
    'madeleine': '마들렌',
    // ... 필요한 만큼 추가
  };

  String getKoreanLabel(String label) {
    return labelToKorean[label] ?? label; // 없으면 영문 그대로 반환
  }

  void onTakePictureAndSearch(BuildContext context) async {
    final image = await pickImage();
    print('📸 pickImage 결과: $image');
    if (image == null) return;

    final engLabels = await sendImageToServer(image.path);
    print('🌏 서버에서 받은 engLabel: $engLabels');
    if (engLabels == null || engLabels.isEmpty) {
      print('❌ 서버에서 라벨을 못받음!');
      return;
    }

    final korLabels = engLabels.map((label) => getKoreanLabel(label)).toList();
    print('🇰🇷 변환된 한글 라벨들: $korLabels');

    // 각 한글 라벨을 기준으로 검색 결과 누적
    List<Map<String, dynamic>> results = [];
    for (final query in korLabels) {
      if (query.trim().isEmpty) continue;
      results.addAll(
        foodList.where((food) => food['name'].contains(query.trim())),
      );
    }

    // 중복 제거 (name이 같은 항목 기준)
    results = results.toSet().toList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SearchResultScreenLn(
              results: results,
              onScoreChanged: widget.onScoreChanged,
            ),
      ),
    );

    if (result == true) {
      setState(() {}); // 화면 갱신(점수도 다시 계산됨)
      if (widget.onScoreChanged != null) {
        await widget.onScoreChanged!(); // 점수 갱신 함수도 실행
      }
    }
  }

  // 카메라 파트 마무리//

  // 사진 파트 시작 //
  Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  void onPickImageFromGalleryAndSearch(BuildContext context) async {
    final image = await pickImageFromGallery();
    print('🖼️ pickImageFromGallery 결과: $image');
    if (image == null) return;

    final engLabels = await sendImageToServer(image.path);
    print('🌏 서버에서 받은 engLabel: $engLabels');
    if (engLabels == null || engLabels.isEmpty) {
      print('❌ 서버에서 라벨을 못받음!');
      return;
    }

    final korLabels = engLabels.map((label) => getKoreanLabel(label)).toList();
    print('🇰🇷 변환된 한글 라벨들: $korLabels');

    List<Map<String, dynamic>> results = [];
    for (final query in korLabels) {
      if (query.trim().isEmpty) continue;
      results.addAll(
        foodList.where((food) => food['name'].contains(query.trim())),
      );
    }

    // 중복 제거
    results = results.toSet().toList();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SearchResultScreenLn(
              results: results,
              onScoreChanged: widget.onScoreChanged,
            ),
      ),
    );

    if (result == true) {
      setState(() {}); // 화면 갱신
      if (widget.onScoreChanged != null) {
        await widget.onScoreChanged!();
      }
    }
  }

  // 사진 파트 마무리 //
  void _updateSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _searchResults =
          foodList
              .where(
                (food) =>
                    food['name'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  Future<void> loadFoodList() async {
    foodList = await FoodCache.loadFoodList(context);
    setState(() {});
  }

  void _searchFood(BuildContext context) {
    String query = _controller.text.trim();
    if (query.isEmpty) return;

    List<Map<String, dynamic>> results =
        foodList.where((food) => food['name'].contains(query)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreenLn(results: results),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(), // 바깥 누르면 닫힘!
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Color.fromRGBO(0, 0, 0, 0.2)),
              ),
            ),
          ),
          Positioned(
            left: (MediaQuery.of(context).size.width - 390) / 2,
            top:
                (screenHeight - 700) / 2 -
                (viewInsets > 0 ? viewInsets / 2 : 0),
            child: SizedBox(
              width: 390,
              height: 700,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFFFFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 뒤로가기 버튼
                    Positioned(
                      left: 24,
                      top: 46,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          'assets/icon/arrow_back.svg',
                          width: 32,
                          height: 32,
                        ),
                      ),
                    ),

                    // 제목
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 46,
                      child: Center(
                        child: Text(
                          '검색하기',
                          style: TextStyle(
                            color: Color(0xFF1A1D1F),
                            fontSize: 24,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ),

                    // 회색 박스
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 150,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 알림창이 아래
                          buildGuideCard(),
                          // 거북이+동그란원이 위에 겹쳐
                          Positioned(
                            top: -30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 1. 그라데이션 동그란 원
                                  Container(
                                    width: 130,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFF6F7FA),
                                          Color(0xFFE8F6F3),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      //borderRadius: BorderRadius.circular(70),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.elliptical(
                                          70,
                                          55,
                                        ), // 윗부분은 곡선
                                        bottom: Radius.circular(0), // 아랫부분은 직선
                                      ),
                                    ),
                                  ),
                                  // 2. 그라데이션 Shim 텍스트
                                  ShaderMask(
                                    shaderCallback:
                                        (bounds) => LinearGradient(
                                          colors: [
                                            Color(0xFF8F80F9),
                                            Color(0xFF5ED593),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            bounds.width,
                                            bounds.height,
                                          ),
                                        ),
                                    child: Text(
                                      "Shim",
                                      style: TextStyle(
                                        fontSize: 30, // 원 안에 들어가도록 크기 맞춰서 조절
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Pretendard', // 버튼과 동일하게!
                                        color: Colors.white, // 반드시 white!
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 초록색 Search 버튼
                    Positioned(
                      left: 44,
                      top: 412,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => onTakePictureAndSearch(context),
                            child: Container(
                              width: 140,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8F80F9),
                                    Color(0xFF5ED593),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icon/Camera.svg', // 아이콘 경로
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '촬영하기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 22),
                          GestureDetector(
                            onTap:
                                () => onPickImageFromGalleryAndSearch(context),
                            child: Container(
                              width: 140,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8F80F9),
                                    Color(0xFF5ED593),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icon/picture.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '불러오기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "직접 입력하기" 텍스트
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 541,
                      child: Center(
                        child: Text(
                          '직접 입력하기',
                          style: TextStyle(
                            color: Color(0xFF1A1D1F),
                            fontSize: 24,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ),

                    // 검색 텍스트필드
                    Positioned(
                      left: 24,
                      top: 600,
                      child: Container(
                        width: 342,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          onChanged: _updateSearchResults,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: '음식명을 입력해주세요!',
                            hintStyle: TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.29,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE5E7EA)),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => _searchFood(context),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SvgPicture.asset(
                                  'assets/icon/search.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ✅ 실시간 검색 결과 리스트
                    if (_searchResults.isNotEmpty)
                      Positioned(
                        left: 24,
                        bottom: 120,
                        child: Container(
                          width: 342,
                          constraints: BoxConstraints(
                            maxHeight: 240, // 최대 높이 4개 정도 (60 * 4 = 240)
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Color(0xFFE5E7EA)),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final food = _searchResults[index];
                              return ListTile(
                                title: Text(
                                  food['name'],
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => SearchResultScreenLn(
                                            results: [food],
                                            onScoreChanged:
                                                widget.onScoreChanged,
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // 초록색 팝업 박스
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildGuideCard() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFF6F7FA), Color(0xFFE8F6F3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(23),
      boxShadow: [
        BoxShadow(
          color: Color(0x158F80F9),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                "음식 인식 인식은 베타 서비스 단계입니다.",
                style: TextStyle(
                  color: Color(0xFF8F80F9),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                "정확도를 높이려면,\n음식을 하나씩 찍는 걸 추천해요.",
                style: TextStyle(
                  color: Colors.black, //Color(0xFF8F80F9),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ℹ️', style: TextStyle(fontSize: 18)),
            SizedBox(width: 7),
            Expanded(
              child: Text(
                "음식을 위쪽에서 정면으로 찍어주세요!",
                style: TextStyle(
                  color: Colors.black, //Color(0xFF8F80F9),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
