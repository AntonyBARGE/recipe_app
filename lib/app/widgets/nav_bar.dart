import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final void Function(int index) onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final double sw = MediaQuery.of(context).size.width;
    const double bottomNavBarLineWidth = 36;
    int navbarItemsSize = items.length;

    return Stack(
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: colors.kPrimaryColor,
          // unselectedItemColor: colors.kBlackColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          elevation: 0,
          selectedLabelStyle: const TextStyle(height: 3),
          unselectedLabelStyle: const TextStyle(height: 3),
          items: items,
          currentIndex: currentIndex,
          onTap: (index) => onTap(index),
        ),
        Positioned(
          top: 0,
          child: AnimatedContainer(
            margin: EdgeInsets.only(
                left: sw / navbarItemsSize * currentIndex +
                    (sw / navbarItemsSize - bottomNavBarLineWidth) / 2),
            width: bottomNavBarLineWidth,
            height: 3,
            // color: colors.kPrimary80,
            duration: const Duration(milliseconds: 100),
          ),
        ),
      ],
    );
  }
}
