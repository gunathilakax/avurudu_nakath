import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import 'countdown_timer.dart';

class EventDetailsPopup extends StatelessWidget {
  final Event event;

  const EventDetailsPopup({required this.event, super.key});

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('hh:mm a', 'si');
    return 'දිනය : ${dateFormat.format(dateTime)}\nවේලාව: ${timeFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen height
    final double padding = screenHeight * 0.02; // 2% of screen height
    final double titleFontSize = screenHeight * 0.035; // 3.5% of screen height
    final double textFontSize = screenHeight * 0.025; // 2.5% of screen height
    final double iconSize = screenHeight * 0.035; // 3.5% of screen height
    final double spacing = screenHeight * 0.015; // 1.5% of screen height

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding * 0.625), // 62.5% of padding
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.8, // Max height 80% of screen (unchanged)
        ),
        padding: EdgeInsets.all(padding), // Padding scales with height
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(padding * 0.625), // 62.5% of padding
        ),
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Use available width minus padding for the image box
                  final availableWidth = constraints.maxWidth - (padding * 2); // Padding on both sides
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Event Image in a Square Box (1:1)
                      Container(
                        padding: EdgeInsets.all(padding * 0.5), // Half padding for image box
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3AE),
                          borderRadius: BorderRadius.circular(padding * 0.625),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: availableWidth,
                            maxHeight: availableWidth, // 1:1 ratio (square)
                          ),
                          child: Image.asset(
                            event.imagePath,
                            width: availableWidth,
                            height: availableWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing), // Spacing scales with height
                      // Event Title (Centered)
                      Text(
                        event.name,
                        style: TextStyle(
                          fontSize: titleFontSize.clamp(20, 28), // Min 20, Max 28
                          color: const Color(0xFF191919),
                          fontFamily: 'UNArundathee',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      // Date and Time
                      Text(
                        _formatDateTime(event.startTime),
                        style: TextStyle(
                          fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                          color: const Color(0xFF191919),
                          fontFamily: 'UNGurulugomi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      // Countdown Timer for Selected Event
                      CountdownTimer(
                        timeUntilNextEvent: event.startTime.difference(DateTime.now()),
                      ),
                      SizedBox(height: spacing),
                      // Description
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                          color: const Color(0xFF191919),
                          fontFamily: 'UNGurulugomi',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            // Fixed Close Button at Top Right (No Background)
            Positioned(
              right: -padding * 0.8125, // ~13/16 of padding, approximates original -13
              top: -padding * 0.8125, // ~13/16 of padding, approximates original -13
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF191919)),
                iconSize: iconSize.clamp(18, 30), // Min 18, Max 30
                padding: EdgeInsets.all(padding * 0.125), // Minimal padding, 12.5% of base padding
                constraints: const BoxConstraints(), // Remove default constraints
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}