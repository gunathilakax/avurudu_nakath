import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  final Duration timeUntilNextEvent;

  const CountdownTimer({required this.timeUntilNextEvent, super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen height
    final double padding = screenHeight * 0.01; // 1% of screen height
    final double textFontSize = screenHeight * 0.025; // 2.5% of screen height
    final double containerWidth = screenHeight * 0.05; // 5% of screen height for width reference

    return SizedBox(
      width: MediaQuery.of(context).size.width - (padding * 2), // Adjust width dynamically
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeUnit(context, 'දින: ', timeUntilNextEvent.inDays, textFontSize, padding),
          _buildTimeUnit(context, 'පැය: ', timeUntilNextEvent.inHours % 24, textFontSize, padding),
          _buildTimeUnit(context, 'මිනි: ', timeUntilNextEvent.inMinutes % 60, textFontSize, padding),
          _buildTimeUnit(context, 'තත්: ', timeUntilNextEvent.inSeconds % 60, textFontSize, padding),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(BuildContext context, String label, int value, double fontSize, double padding) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize.clamp(16, 24), // Min 16, Max 24
            color: const Color(0xFF191919),
            fontFamily: 'UNGurulugomi',
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5), // Vertical padding is half of horizontal
          decoration: BoxDecoration(
            color: const Color(0xFFFFE3AE),
            borderRadius: BorderRadius.circular(padding * 0.4), // 40% of padding
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: fontSize.clamp(16, 24), // Min 16, Max 24
              color: const Color(0xFF191919),
              fontFamily: 'UNGurulugomi',
            ),
          ),
        ),
      ],
    );
  }
}