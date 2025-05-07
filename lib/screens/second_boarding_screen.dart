import 'package:flutter/material.dart';

class SecondBoardingScreen extends StatelessWidget {
  const SecondBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),

            // 📌 Bigger Image
            Image.asset(
              "assets/images/group335.png",
              width: screenSize.width * 1,
              height: screenSize.height * 0.55,
              fit: BoxFit.contain,
            ),

            // 📌 Rounded Container for Text
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Test yout knowledge \n with QuizPi!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Lorem Ipsum Lorem Ipsum Lorem\n"
                      "Ipsum Lorem Ipsum Lorem Ipsum\n"
                      "Lorem Ipsum Lorem Ipsum",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
