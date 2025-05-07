import 'package:flutter/material.dart';
import 'package:flutter_application_132/bottom_section.dart';
import 'package:flutter_application_132/screens/first_boarding_screen.dart';
import 'package:flutter_application_132/screens/second_boarding_screen.dart';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  PageController myController = PageController();
  bool isLastScreen = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: myController,
          children: const [FirstBoardingScreen(), SecondBoardingScreen()],
          onPageChanged: (page) {
            setState(() {
              isLastScreen = (page == 1);
            });
          },
        ),
        BottomSection(isLastScreen: isLastScreen, controller: myController),
      ],
    );
  }
}
