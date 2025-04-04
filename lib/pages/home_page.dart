import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.3;
    final double imageWidth = screenHeight * 0.5;
    final double titleFontSize = screenHeight * 0.09;
    final double spacing = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Content section
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/sun.png',
                        width: imageWidth.clamp(150, 300),
                        height: imageHeight.clamp(100, 240),
                      ),
                      SizedBox(height: spacing * 0.8),
                      Text(
                        'අපේ අවුරුදු\nනැකත්',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize.clamp(44, 88),
                          color: AppConstants.textColor,
                          height: 0.8,
                          fontFamily: AppConstants.fontPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Button section - positioned higher up from bottom
              Container(
                margin: EdgeInsets.only(
                  bottom: screenHeight * 0.15,
                ), // Adjust this value to move button up
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DashboardPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentColor,
                    foregroundColor: AppConstants.textColor,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.5,
                      40, // Reduced from 48 to 44 to make the button height smaller
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical:
                          6, // Reduced from 12 to 10 to make the button smaller
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'නැකත් ලැයිස්තුව',
                        style: TextStyle(
                          fontSize:
                              24, // Increased from 18 to 20 for bigger text
                          fontFamily: AppConstants.fontPrimary,
                          color: AppConstants.textColor,
                          fontWeight:
                              FontWeight
                                  .w500, // Added slight boldness for better visibility
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: AppConstants.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
