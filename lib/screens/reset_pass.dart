import 'package:flutter/material.dart';
import 'password_changed.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // 📌 Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            // 📌 Header Text
            const Text(
              "Create New Password",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // 📌 Description Text
            const Text(
              "Your new password must be unique from those previously used.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 25),

            // 📌 New Password Input
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                obscureText: _isObscure1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'New Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure1 = !_isObscure1;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📌 Confirm Password Input
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                obscureText: _isObscure2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Confirm Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure2 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 📌 Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Password Changed Page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordChangedPage(),
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
                  "Reset Password",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
