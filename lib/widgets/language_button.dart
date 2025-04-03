import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const LanguageButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double fontSize = screenHeight * 0.025;
    final double buttonHeight = screenHeight * 0.05;
    final double buttonWidth = MediaQuery.of(context).size.width * 0.5;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFFFCD71) : const Color(0xFFFFE3AE), // Updated colors
        foregroundColor: const Color(0xFF191919),
        minimumSize: Size(
          buttonWidth,
          buttonHeight.clamp(36, 60),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenHeight * 0.02,
          vertical: screenHeight * 0.01,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenHeight * 0.01),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize.clamp(16, 24),
          fontFamily: 'Roboto',
          color: const Color(0xFF191919),
        ),
      ),
    );
  }
}