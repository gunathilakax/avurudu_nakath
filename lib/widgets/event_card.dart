import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenHeight * 0.02;
    final double margin = screenHeight * 0.0125;
    final double textFontSize = screenHeight * 0.025;
    final double spacing = screenHeight * 0.01;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - (padding * 4),
        margin: EdgeInsets.only(bottom: margin),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.secondaryColor : AppConstants.accentColor,
          borderRadius: BorderRadius.circular(padding * 0.625),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: TextStyle(
                fontSize: textFontSize.clamp(16, 24),
                color: AppConstants.textColor,
                fontFamily: AppConstants.fontSecondary,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              event.description,
              style: TextStyle(
                fontSize: textFontSize.clamp(16, 24),
                color: AppConstants.textColor,
                fontFamily: AppConstants.fontPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}