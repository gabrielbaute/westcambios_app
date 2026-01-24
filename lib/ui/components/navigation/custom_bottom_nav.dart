import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: WestColors.grayDark.withOpacity(0.1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          selectedIndex: currentIndex,
          onTabChange: onTabChange,
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: WestColors.whitePure,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: WestColors.orangeLight,
          color: Colors.black54,
          tabs: const [
            GButton(icon: Icons.calculate_outlined, text: 'Calculadora'),
            GButton(icon: Icons.trending_up, text: 'Tasas'),
            GButton(icon: Icons.notifications_none, text: 'Alertas'),
          ],
        ),
      ),
    );
  }
}
