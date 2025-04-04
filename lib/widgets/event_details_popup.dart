import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/event.dart';
import '../services/time_service.dart';
import '../utils/date_utils.dart' as CustomDateUtils;
import 'countdown_timer.dart';

class EventDetailsPopup extends StatefulWidget {
  final Event event;

  const EventDetailsPopup({required this.event, super.key});

  @override
  _EventDetailsPopupState createState() => _EventDetailsPopupState();
}

class _EventDetailsPopupState extends State<EventDetailsPopup> {
  late Timer _timer;
  Duration timeUntilNextEvent = Duration.zero;

  @override
  void initState() {
    super.initState();
    timeUntilNextEvent = TimeService.getTimeUntilEvent(widget.event.startTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeUntilNextEvent = TimeService.getTimeUntilEvent(widget.event.startTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenHeight * 0.02;
    final double titleFontSize = screenHeight * 0.035;
    final double textFontSize = screenHeight * 0.025;
    final double iconSize = screenHeight * 0.035;
    final double spacing = screenHeight * 0.015;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding * 0.625)),
      child: Container(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: AppConstants.backgroundColor,
          borderRadius: BorderRadius.circular(padding * 0.625),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth - (padding * 2);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: iconSize.clamp(18, 30) + spacing),
                      Container(
                        padding: EdgeInsets.all(padding * 0.5),
                        decoration: BoxDecoration(
                          color: AppConstants.accentColor,
                          borderRadius: BorderRadius.circular(padding * 0.625),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: availableWidth, maxHeight: availableWidth),
                          child: Image.asset(widget.event.imagePath, width: availableWidth, height: availableWidth, fit: BoxFit.contain),
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        widget.event.name,
                        style: TextStyle(
                          fontSize: titleFontSize.clamp(20, 28),
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      Text(
                        CustomDateUtils.DateUtils.formatDateTime(widget.event.startTime, AppConstants.localeSinhala),
                        style: TextStyle(
                          fontSize: textFontSize.clamp(16, 24),
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing),
                      CountdownTimer(timeUntilNextEvent: timeUntilNextEvent),
                      SizedBox(height: spacing),
                      Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: textFontSize.clamp(16, 24),
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: iconSize.clamp(18, 30),
                height: iconSize.clamp(18, 30),
                decoration: const BoxDecoration(
                  color: AppConstants.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppConstants.textColor),
                  iconSize: iconSize.clamp(18, 30),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}