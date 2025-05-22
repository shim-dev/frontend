// import 'package:capstone_trial_01/globals.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
//
// class ScoreBadge extends StatefulWidget {
//   final String iconPath; // 아이콘 경로 받기
//   final String mealType; // 아침, 점심, 저녁
//
//   const ScoreBadge({super.key, required this.iconPath, required this.mealType});
//
//   @override
//   _ScoreBadgeState createState() => _ScoreBadgeState();
// }
//
// class _ScoreBadgeState extends State<ScoreBadge> {
//   int score = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     calculateTodayScore();
//
//     scoreUpdateNotifier.addListener(() {
//       calculateTodayScore();
//     });
//   }
//
//   void didUpdateWidget(covariant ScoreBadge oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     calculateTodayScore(); // ✅ 위젯이 업데이트될 때마다 점수 다시 계산
//   }
//
//   void calculateTodayScore() {
//     String today = DateFormat('yyyy.MM.dd').format(DateTime.now());
//     print("📅 오늘 날짜: $today");
//     print("📂 breakfastRecords: $breakfastRecords");
//
//     double total = 0;
//
//     if (breakfastRecords.containsKey(today)) {
//       print("✅ 오늘 추가된 음식 목록: ${breakfastRecords[today]}");
//       for (var food in breakfastRecords[today]!) {
//         print("🍽️ 음식 데이터: $food");
//
//         double calcium = food['calcium_mg'] ?? 0;
//         double fiber = food['fiber_g'] ?? 0;
//
//         print("🧮 calcium: $calcium, fiber: $fiber");
//
//         total += (calcium * 20) + (fiber * 30);
//       }
//     } else {
//       print("🚫 오늘 날짜로 저장된 음식 없음!");
//     }
//
//     print("🎯 최종 계산된 점수: $total");
//
//     setState(() {
//       score = total.toInt();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Color(0xD80A8356),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset(widget.iconPath, width: 30, height: 30),
//           SizedBox(width: 8),
//           Text(
//             "$score점",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontFamily: 'Pretendard',
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
