import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../data/event_data.dart';
import '../models/event.dart';
import '../services/time_service.dart';
import '../utils/date_utils.dart' as CustomDateUtils;
import '../widgets/event_card.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/event_details_popup.dart';

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
    _selectNearestEvent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolledToNextEvent && _scrollController.hasClients) {
        _scrollToNextEvent();
        _hasScrolledToNextEvent = true;
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (nextEvent != null) {
          timeUntilNextEvent = TimeService.getTimeUntilEvent(
            nextEvent!.startTime,
          );
          _selectNearestEvent();
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

  void _selectNearestEvent() {
    if (events.isNotEmpty) {
      events.sort((a, b) => a.startTime.compareTo(b.startTime));
      setState(() {
        nextEvent = events.firstWhere(
          (event) => event.startTime.isAfter(DateTime.now()),
          orElse: () => events.first,
        );
        timeUntilNextEvent = TimeService.getTimeUntilEvent(
          nextEvent!.startTime,
        );
        selectedEvent ??= nextEvent;
      });
    }
  }

  void _scrollToNextEvent() {
    if (nextEvent != null && _scrollController.hasClients) {
      final nextEventIndex = events.indexOf(nextEvent!);
      if (nextEventIndex >= 0) {
        final screenHeight = MediaQuery.of(context).size.height;
        final cardHeight = screenHeight * 0.18;
        final offset = nextEventIndex * cardHeight;
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (_) => EventDetailsPopup(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenHeight * 0.02;
    final double headerFontSize = screenHeight * 0.04;
    final double textFontSize = screenHeight * 0.025;
    final double spacing = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: AppConstants.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding * 0.625,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.greeting,
                    style: TextStyle(
                      fontSize: headerFontSize.clamp(24, 40),
                      color: AppConstants.accentColor,
                      fontFamily: AppConstants.fontPrimary,
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
                        color: AppConstants.backgroundColor,
                        borderRadius: BorderRadius.circular(padding * 0.625),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppConstants.nextEventLabel}${nextEvent?.name ?? ''}',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24),
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontSecondary,
                            ),
                          ),
                          SizedBox(height: spacing),
                          Text(
                            nextEvent != null
                                ? CustomDateUtils.DateUtils.formatDateTime(
                                  nextEvent!.startTime,
                                  AppConstants.localeSinhala,
                                )
                                : '',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24),
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontPrimary,
                            ),
                          ),
                          SizedBox(height: spacing),
                          CountdownTimer(
                            timeUntilNextEvent: timeUntilNextEvent,
                          ),
                          SizedBox(height: spacing),
                          Text(
                            nextEvent?.description ?? '',
                            style: TextStyle(
                              fontSize: textFontSize.clamp(16, 24),
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontPrimary,
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
                                  color: AppConstants.accentColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: padding * 0.5,
                                ),
                                child: Text(
                                  AppConstants.eventListLabel,
                                  style: TextStyle(
                                    fontSize: headerFontSize.clamp(24, 40),
                                    color: AppConstants.accentColor,
                                    fontFamily: AppConstants.fontPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppConstants.accentColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing * 0.67),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(padding),
                              decoration: BoxDecoration(
                                color: AppConstants.backgroundColor,
                                borderRadius: BorderRadius.circular(
                                  padding * 0.625,
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                      AppConstants.primaryColor,
                                    ),
                                  ),
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
                                        setState(() => selectedEvent = event);
                                        _showEventDetails(context, event);
                                      },
                                    );
                                  },
                                ),
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
