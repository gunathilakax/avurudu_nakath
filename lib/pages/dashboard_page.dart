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
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToNextEvent = false;

  @override
  void initState() {
    super.initState();
    events = EventData.events;
    selectNearestEvent();

    // Scroll to the next event only on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolledToNextEvent && _scrollController.hasClients) {
        scrollToNextEvent();
        _hasScrolledToNextEvent = true;
      }
    });

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
    _scrollController.dispose();
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

  void scrollToNextEvent() {
    if (nextEvent != null && _scrollController.hasClients) {
      final nextEventIndex = events.indexOf(nextEvent!);
      if (nextEventIndex >= 0) {
        // Estimate EventCard height based on its design
        final cardHeight = screenHeight * 0.18; // Adjusted to match EventCard height
        final offset = nextEventIndex * cardHeight;

        // Ensure the offset aligns the top of the card with the top of the ListView
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
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

  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    final double padding = screenHeight * 0.02;
    final double headerFontSize = screenHeight * 0.04;
    final double subHeaderFontSize = screenHeight * 0.03;
    final double textFontSize = screenHeight * 0.025;
    final double iconSize = screenHeight * 0.035;
    final double spacing = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: const Color(0xFFF5C15C),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.625),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/sun.png',
                    height: iconSize.clamp(20, 36),
                    width: iconSize.clamp(20, 36),
                  ),
                  SizedBox(width: spacing * 0.5),
                  Text(
                    'සුභ අළුත් අවුරුද්දක් වේවා!',
                    style: TextStyle(
                      fontSize: headerFontSize.clamp(24, 40),
                      color: const Color(0xFF191919),
                      fontFamily: 'UNDisapamok',
                    ),
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
                              fontSize: textFontSize.clamp(16, 24),
                              color: const Color(0xFF191919),
                              fontFamily: 'UNArundathee',
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            nextEvent != null ? _formatDateTime(nextEvent!.startTime) : '',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24),
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
                              fontSize: textFontSize.clamp(16, 24),
                              color: const Color(0xFF191919),
                              fontFamily: 'UNGurulugomi',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing * 1.33),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFF191919),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: padding * 0.5),
                                child: Text(
                                  'නැකත් ලැයිස්තුව',
                                  style: TextStyle(
                                    fontSize: headerFontSize.clamp(24, 40),
                                    color: const Color(0xFF191919),
                                    fontFamily: 'UNDisapamok',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: const Color(0xFF191919),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing * 0.67),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFEFEF),
                                borderRadius: BorderRadius.circular(padding * 0.625),
                              ),
                              child: Scrollbar(
                                controller: _scrollController,
                                thumbVisibility: true,
                                radius: Radius.circular(padding * 0.5),
                                child: ListView.builder(
                                  controller: _scrollController,
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