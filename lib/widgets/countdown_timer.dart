import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CountdownTimer extends StatelessWidget {
  final Duration timeUntilNextEvent;

  const CountdownTimer({required this.timeUntilNextEvent, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenHeight * 0.01;
    final double textFontSize = screenHeight * 0.025;
    final bool hasEnded = timeUntilNextEvent.inSeconds <= 0;

    return SizedBox(
      width: MediaQuery.of(context).size.width - (padding * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimeUnit(context, 'දින: ', hasEnded ? 0 : timeUntilNextEvent.inDays, textFontSize, padding),
          _buildTimeUnit(context, 'පැය: ', hasEnded ? 0 : timeUntilNextEvent.inHours % 24, textFontSize, padding),
          _buildTimeUnit(context, 'මිනි: ', hasEnded ? 0 : timeUntilNextEvent.inMinutes % 60, textFontSize, padding),
          _buildTimeUnit(context, 'තත්: ', hasEnded ? 0 : timeUntilNextEvent.inSeconds % 60, textFontSize, padding),
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
            fontSize: fontSize.clamp(16, 24),
            color: AppConstants.textColor,
            fontFamily: AppConstants.fontPrimary,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.5),
          decoration: BoxDecoration(
            color: AppConstants.accentColor,
            borderRadius: BorderRadius.circular(padding * 0.4),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: fontSize.clamp(16, 24),
              color: AppConstants.textColor,
              fontFamily: AppConstants.fontPrimary,
            ),
          ),
        ),
      ],
    );
  }
}