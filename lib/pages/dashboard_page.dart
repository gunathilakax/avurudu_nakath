import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/event_details_popup.dart';
import '../data/event_data.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Event> events;
  Event? nextEvent;
  Event? selectedEvent;
  Timer? timer;
  Duration timeUntilNextEvent = Duration.zero;

  @override
  void initState() {
    super.initState();
    events = EventData.events;
    selectNearestEvent();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (nextEvent != null) {
          timeUntilNextEvent = nextEvent!.startTime.difference(DateTime.now());
          selectNearestEvent();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void selectNearestEvent() {
    if (events.isNotEmpty) {
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
      setState(() {
        nextEvent = events.firstWhere(
          (event) => event.startTime.isAfter(DateTime.now()),
          orElse: () => events.first,
        );
        timeUntilNextEvent = nextEvent!.startTime.difference(DateTime.now());
        selectedEvent ??= nextEvent;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('hh:mm a', 'si');
    return 'දිනය : ${dateFormat.format(dateTime)}\nවේලාව: ${timeFormat.format(dateTime)}';
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventDetailsPopup(event: event);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes based on screen height
    final double padding = screenHeight * 0.02; // 2% of screen height
    final double headerFontSize = screenHeight * 0.04; // 4% of screen height
    final double subHeaderFontSize = screenHeight * 0.03; // 3% of screen height
    final double textFontSize = screenHeight * 0.025; // 2.5% of screen height
    final double iconSize = screenHeight * 0.035; // 3.5% of screen height
    final double spacing = screenHeight * 0.015; // 1.5% of screen height

    return Scaffold(
      backgroundColor: const Color(0xFFF5C15C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.625), // Vertical padding is 62.5% of horizontal
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'සුභ අළුත් අවුරුද්දක් වේවා!',
                    style: TextStyle(
                      fontSize: headerFontSize.clamp(24, 40), // Min 24, Max 40
                      color: const Color(0xFF191919),
                      fontFamily: 'UNDisapamok',
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.translate, color: const Color(0xFF191919)),
                        iconSize: iconSize.clamp(20, 36), // Min 20, Max 36
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications, color: const Color(0xFF191919)),
                        iconSize: iconSize.clamp(20, 36), // Min 20, Max 36
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(padding * 0.625),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'මීළග නැකත : ${nextEvent?.name ?? ''}',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                              color: const Color(0xFF191919),
                              fontFamily: 'UNArundathee',
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            nextEvent != null ? _formatDateTime(nextEvent!.startTime) : '',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                              color: const Color(0xFF191919),
                              fontFamily: 'UNGurulugomi',
                            ),
                          ),
                          SizedBox(height: spacing),
                          CountdownTimer(timeUntilNextEvent: timeUntilNextEvent),
                          SizedBox(height: spacing),
                          Text(
                            nextEvent?.description ?? '',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24), // Min 16, Max 24
                              color: const Color(0xFF191919),
                              fontFamily: 'UNGurulugomi',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing * 1.33), // 1.33x spacing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'නැකත් ලැයිස්තුව',
                            style: TextStyle(
                              fontSize: headerFontSize.clamp(24, 40), // Min 20, Max 32
                              color: const Color(0xFF191919),
                              fontFamily: 'UNDisapamok',
                            ),
                          ),
                          SizedBox(height: spacing * 0.67), // 0.67x spacing
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEFEF),
                                borderRadius: BorderRadius.circular(padding * 0.625),
                              ),
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  return EventCard(
                                    event: event,
                                    isSelected: event == selectedEvent,
                                    onTap: () {
                                      setState(() {
                                        selectedEvent = event;
                                      });
                                      _showEventDetails(context, event);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}