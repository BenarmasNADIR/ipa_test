import 'package:flutter/material.dart';
import 'page3.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage2> {
  // Define state variables for the switches
  bool isNotificationEnabled = true;
  bool isSoundEnabled = true;
  bool isVibrateEnabled = true;

  // Define controllers for editable fields
  TextEditingController fullNameController = TextEditingController(
    text: "John Smith",
  );
  TextEditingController dobController = TextEditingController(
    text: "09 / 10 / 1991",
  );
  TextEditingController emailController = TextEditingController(
    text: "john@example.comcomcom",
  );

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
      body: Padding(
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
                ), // Rounded corners for the card
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Aligning the content to center
                children: [
                  const Center(
                    child: Text(
                      "Personal Info",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF), // White color for the title
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF62B2FF),
                          size: 40,
                        ), // Avatar icon
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Color(0xFF62B2FF)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Upload a new picture',
                          style: TextStyle(
                            color: Color(0xFF62B2FF),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Full Name:',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Container(
                            width: 146,
                            height: 25,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE9F6FE),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFE8ECF4),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: TextField(
                              controller: fullNameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ), // Adjust padding
                                isDense:
                                    true, // Makes the TextField more compact
                              ),
                              style: const TextStyle(
                                fontSize:
                                    14, // Reduced font size to fit text in the container
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines:
                                  1, // Ensure it's a single-line TextField
                              textAlignVertical: TextAlignVertical
                                  .center, // Vertically center the text
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date of Birth:',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Container(
                            width: 146,
                            height: 25,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE9F6FE),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFE8ECF4),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: TextField(
                              controller: dobController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ), // Adjust padding
                                isDense:
                                    true, // Makes the TextField more compact
                              ),
                              style: const TextStyle(
                                fontSize:
                                    14, // Reduced font size to fit text in the container
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines:
                                  1, // Ensure it's a single-line TextField
                              textAlignVertical: TextAlignVertical
                                  .center, // Vertically center the text
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Email:',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Container(
                            width: 146,
                            height: 25,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFE9F6FE),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFE8ECF4),
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 0,
                                ),
                                isDense:
                                    true, // Reduces the height of the TextField
                              ),
                              style: const TextStyle(
                                fontSize:
                                    14, // Reduced font size to fit text in the container
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines:
                                  1, // Ensure it's a single-line TextField
                              textAlignVertical: TextAlignVertical
                                  .center, // Vertically center the text
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Save All Changes Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF31BCE2), Color(0xFF0664AE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: ElevatedButton(
                onPressed: () {
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
            ),
          ],
        ),
      ),
    );
  }
}
