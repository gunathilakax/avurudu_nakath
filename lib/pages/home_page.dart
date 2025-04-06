import 'package:flutter/material.dart';
import 'package:avurudu_nakath/pages/dashboard_page.dart'; // Adjust import path as needed
import '../constants/app_constants.dart'; // Adjust import path as needed

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30), // Rotation speed set to 20 seconds
      vsync: this,
    )..repeat(); // Makes the animation loop continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenHeight * 0.09;
    final double spacing = screenHeight * 0.05;
    
    // Make image dimensions square (same width and height)
    final double imageSize = screenWidth; // Full square size (width = height)
    final double visibleImageHeight = imageSize / 2; // Only show half vertically

    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top sun image (showing bottom half at the top of screen)
            Container(
              width: screenWidth, // Full width
              height: visibleImageHeight, // Half of the image height
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: OverflowBox(
                maxHeight: imageSize,
                alignment: Alignment.bottomCenter, // Bottom alignment ensures top half is clipped
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14159,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/sun.png',
                          width: imageSize, // Square dimensions
                          height: imageSize, // Square dimensions
                          fit: BoxFit.cover, // Cover ensures image fills the square
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Middle content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'අපේ අවුරුදු\nනැකත්',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize.clamp(44.0, 88.0),
                        color: AppConstants.accentColor,
                        height: 0.8,
                        fontFamily: AppConstants.fontPrimary,
                      ),
                    ),
                    SizedBox(height: spacing * 1.5), // Increased from spacing to spacing * 1.5
                    

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.accentColor,
                        foregroundColor: AppConstants.textColor,
                        minimumSize: Size(screenHeight * 0.2, screenHeight * 0.055), // Reduced width from 0.5 to 0.45, height from 0.065 to 0.055
                        padding: EdgeInsets.symmetric(
                          horizontal: screenHeight * 0.05, // Kept as is
                          vertical: screenHeight * 0.01,  // Kept as is
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
                              fontSize: (screenHeight * 0.06).clamp(18.0, 24.0),
                              fontFamily: AppConstants.fontPrimary,
                              color: AppConstants.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: screenHeight * 0.02),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: (screenHeight * 0.04).clamp(16.0, 20.0),
                            color: AppConstants.textColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom sun image (showing top half at the bottom of screen)
            Container(
              width: screenWidth, // Full width
              height: visibleImageHeight, // Half of the image height
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: OverflowBox(
                maxHeight: imageSize,
                alignment: Alignment.topCenter, // Top alignment ensures bottom half is clipped
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.14159,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/images/sun.png',
                          width: imageSize, // Square dimensions
                          height: imageSize, // Square dimensions
                          fit: BoxFit.cover, // Cover ensures image fills the square
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}