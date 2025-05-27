// custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<String> icons = [
      'assets/icon/icon_home.svg',
      'assets/icon/calender.svg',
      'assets/icon/icon_people.svg',
      'assets/icon/icon_my.svg',
    ];

    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 20,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(icons.length, (index) {
          return InkWell(
            onTap: () => onTap(index),
            child: SvgPicture.asset(
              icons[index],
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                selectedIndex == index
                    ? const Color(0xFF0A8356)
                    : const Color(0xFFBDBDBD),
                BlendMode.srcIn,
              ),
            ),
          );
        }),
      ),
    );
  }
}
