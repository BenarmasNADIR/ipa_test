// lib/navigation/nav_bar.dart
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:ui';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                gap: 8,
                activeColor: Colors.blue,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.transparent,
                color: Colors.grey[600],
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                    iconColor: Colors.grey[600],
                    iconActiveColor: Colors.blue,
                  ),
                  GButton(
                    icon: LineIcons.history,
                    text: 'History',
                    iconColor: Colors.grey[600],
                    iconActiveColor: Colors.blue,
                  ),
                  GButton(
                    icon: LineIcons.list,
                    text: 'Quizzes',
                    iconColor: Colors.grey[600],
                    iconActiveColor: Colors.blue,
                  ),
                  GButton(
                    icon: LineIcons.cog,
                    text: 'Settings',
                    iconColor: Colors.grey[600],
                    iconActiveColor: Colors.blue,
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: onTabChange,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
