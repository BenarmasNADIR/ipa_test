import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import Login Screen
import 'otp_verification.dart'; // Import OTP Verification Screen

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            // 📌 Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 40),

            // 📌 Header Text
            const Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // 📌 Description Text
            const Text(
              "Don't worry! It occurs. Please enter the email address linked with your account.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 25),

            // 📌 Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your email and Phone no.',
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Send Code Button (Navigate to OTP Verification)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to OTP Verification Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OTPVerificationPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Send Code",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            // 📌 "Remember Password? Login Now" Link
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigate to Login Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Remember Password? ",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Login Now",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
