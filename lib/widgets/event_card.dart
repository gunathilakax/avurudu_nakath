import 'package:flutter/material.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool isSelected;
  final VoidCallback onTap;

  const EventCard({
    required this.event,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen height
    final double padding = screenHeight * 0.02; // 2% of screen height
    final double margin = screenHeight * 0.0125; // 1.25% of screen height
    final double textFontSize = screenHeight * 0.025; // 2.5% of screen height
    final double spacing = screenHeight * 0.01; // 1% of screen height

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - (padding * 4), // Adjust width dynamically
        margin: EdgeInsets.only(bottom: margin), // Margin scales with height
        padding: EdgeInsets.all(padding), // Padding scales with height
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFCD71) : const Color(0xFFFFE3AE),
          borderRadius: BorderRadius.circular(padding * 0.625), // 62.5% of padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: TextStyle(
                fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                color: const Color(0xFF191919),
                fontFamily: 'UNArundathee',
              ),
            ),
            SizedBox(height: spacing), // Spacing scales with height
            Text(
              event.description,
              style: TextStyle(
                fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                color: const Color(0xFF191919),
                fontFamily: 'UNGurulugomi',
              ),
            ),
          ],
        ),
      ),
    );
  }
}