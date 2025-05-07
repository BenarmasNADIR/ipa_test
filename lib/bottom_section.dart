import 'package:flutter/material.dart';
import 'package:flutter_application_132/screens/login_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter_application_132/colors.dart';

class BottomSection extends StatefulWidget {
  final PageController controller;
  final bool isLastScreen;

  const BottomSection({
    super.key,
    required this.controller,
    required this.isLastScreen,
  });

  @override
  State<BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<BottomSection> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),

          // CircularPercentIndicator with button inside
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularPercentIndicator(
                  radius: 40,
                  animation: true,
                  animationDuration: 300,
                  percent: widget.isLastScreen ? 1 : 0.3,
                  animateFromLastPercent: true,
                  progressColor: ColorPallete.mainColor,
                  backgroundColor: Colors.grey.shade300,
                  center: CircleAvatar(
                    radius: 30,
                    backgroundColor: ColorPallete.mainColor,
                    child: IconButton(
                      onPressed: () {
                        widget.isLastScreen
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              )
                            : widget.controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                      },
                      icon: Icon(
                        widget.isLastScreen
                            ? Icons.check
                            : Icons.keyboard_arrow_right,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Skip button
          widget.isLastScreen
              ? const SizedBox(height: 19)
              : GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: ColorPallete.mainColor,
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),

          const SizedBox(height: 10),

          // SmoothPageIndicator slightly raised and aligned left
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Transform.translate(
                  offset: const Offset(0, -90), // Moves up by 5 pixels
                  child: SmoothPageIndicator(
                    controller: widget.controller,
                    count: 2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
