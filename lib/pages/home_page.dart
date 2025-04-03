import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/language_button.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen height
    final double imageHeight = screenHeight * 0.3; // 30% of screen height
    final double imageWidth = screenHeight * 0.5; // 50% of screen height
    final double titleFontSize = screenHeight * 0.09; // Increased from 0.08 to 0.09 (8% to 9%)
    final double spacing = screenHeight * 0.05; // 5% of screen height

    return Scaffold(
      backgroundColor: const Color(0xFFF5C15C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/sun.png',
              width: imageWidth.clamp(150, 300), // Min 150, Max 300
              height: imageHeight.clamp(100, 240), // Min 100, Max 240
            ),
            SizedBox(height: spacing * 1.2), // 1.2x spacing (approx. original 60)
            Text(
              'අපේ අවුරුදු\nනැකත්',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: titleFontSize.clamp(44, 88), // Increased min/max from 40-80 to 44-88
                color: const Color(0xFF191919),
                height: 0.8, // Line height unchanged
              ),
            ),
            SizedBox(height: spacing * 1.5), // Increased from 1.2x to 1.5x for larger gap
            LanguageButton(
              text: 'සිංහල',
              isSelected: selectedLanguage == 'sinhala',
              onPressed: () {
                setState(() => selectedLanguage = 'sinhala');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
              },
            ),
            SizedBox(height: spacing * 0.2), // 0.2x spacing (approx. original 10)
            LanguageButton(
              text: 'தமிழ்',
              isSelected: selectedLanguage == 'tamil',
              onPressed: () {
                setState(() => selectedLanguage = 'tamil');
                // Placeholder for Tamil navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tamil support coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}