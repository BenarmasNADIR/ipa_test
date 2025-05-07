import 'package:flutter/material.dart';
import 'package:flutter_application_132/integration/models/models.dart';
import 'package:flutter_application_132/pages/home.dart';
import 'package:flutter_application_132/pages/history.dart';
import 'package:flutter_application_132/pages/quizzes.dart';
import 'package:flutter_application_132/pages/settings.dart';
import 'package:flutter_application_132/navigation/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Initialize pages with user data if available
    _pages = [
      HomeScreen(username: widget.user?.username ?? "Guest"),
      const HistoryScreen(),
      const QuizzesScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
