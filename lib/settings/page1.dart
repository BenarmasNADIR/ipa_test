import 'package:flutter/material.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Define state variables for the switches
  bool isNotificationEnabled = true;
  bool isSoundEnabled = true;
  bool isVibrateEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light gray background for the box
            borderRadius: BorderRadius.circular(
              12,
            ), // Rounded corners for the box
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous page
            },
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrap the content in a scrollable view
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ), // Add space between the back button and the title
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 32, // Adjusted for font size
                fontFamily:
                    'ChalkboardSE', // Assuming you've added the font in your assets
                fontWeight:
                    FontWeight.w400, // Corrected to use Flutter's FontWeight
                color: Color(0xFF262626), // Set color to #262626
              ),
            ),
            const SizedBox(height: 24), // Add space after the title
            // Personal Info Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF31BCE2), // Start color (#31BCE2)
                    Color(0xFF0664AE), // End color (#0664AE)
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  21.67,
                ), // Set border-radius to 21.67px
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Personal Info",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF62B2FF),
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        // Make the row content flexible to avoid overflow
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Full Name: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'John Smith',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date of Birth: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '09 / 10 / 1991',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'john@example.com',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage2(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notification Switches Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isNotificationEnabled
                          ? Icons.notifications
                          : Icons.notifications_off,
                      color: isNotificationEnabled
                          ? const Color(0xFF0C71B5)
                          : const Color.fromRGBO(12, 113, 181, 0.4),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'General Notification',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isNotificationEnabled = value;
                      });
                    },
                    inactiveThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF0C71B5),
                    inactiveTrackColor: const Color.fromRGBO(12, 113, 181, 0.4),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: isSoundEnabled
                          ? const Color(0xFF0C71B5)
                          : const Color.fromRGBO(12, 113, 181, 0.4),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sound',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isSoundEnabled,
                    onChanged: (value) {
                      setState(() {
                        isSoundEnabled = value;
                      });
                    },
                    inactiveThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF0C71B5),
                    inactiveTrackColor: const Color.fromRGBO(12, 113, 181, 0.4),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.vibration,
                      color: isVibrateEnabled
                          ? const Color(0xFF0C71B5)
                          : const Color.fromRGBO(12, 113, 181, 0.4),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Vibration',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: isVibrateEnabled,
                    onChanged: (value) {
                      setState(() {
                        isVibrateEnabled = value;
                      });
                    },
                    inactiveThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF0C71B5),
                    inactiveTrackColor: const Color.fromRGBO(12, 113, 181, 0.4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              width: double.infinity, // Full-width button
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF31BCE2),
                    Color(0xFF0664AE),
                  ], // Gradient colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(
                  18,
                ), // Apply border-radius of 18px
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Action for the first button, for example, navigating to the profile update page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const page3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors
                      .transparent, // Set transparent to let the gradient show
                  shadowColor: Colors
                      .transparent, // Remove shadow to match the gradient style
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      18,
                    ), // Match the border-radius
                  ),
                ),
                child: const Text('Save All Changes',
                    style: TextStyle(fontSize: 16)),
              ),
            ), // Adjust spacing to handle small screens
          ],
        ),
      ),
    );
  }
}
