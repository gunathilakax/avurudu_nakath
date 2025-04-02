import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'dart:async'; // For the countdown timer

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required when using platform channels

  // Set app to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avurudu Nakath',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'UNDisapamok', // Custom font applied globally
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track which language button is selected
  String selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5C15C), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sun Image
            Image.asset(
              'assets/sun.png',
              width: MediaQuery.of(context).size.width * 0.6, // Responsive width
              height: MediaQuery.of(context).size.height * 0.3, // Responsive height
            ),
            SizedBox(height: 60), // Spacing between image and text
            // Main Text with reduced line spacing
            Text(
              'අපේ අවුරුදු\nනැකත්', // Text with newline
              textAlign: TextAlign.center, // Center-align the text
              style: TextStyle(
                fontSize: 64, // Font size as previously set
                color: Color(0xFF191919), // Text color
                height: 0.8, // Reduced line spacing (default is ~1.2)
              ),
            ),
            SizedBox(height: 60), // Spacing to move buttons down
            // Sinhala Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedLanguage = 'sinhala';
                });
                // Navigate to DashboardPage with Sinhala language
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedLanguage == 'sinhala'
                    ? Color(0xFFFFE3AE)
                    : Color(0xFFEFEFEF), // Change color when selected
                foregroundColor: Color(0xFF191919), // Button text color
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 36), // Button height
              ),
              child: Text(
                'සිංහල',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto', // Normal font instead of custom
                ),
              ),
            ),
            SizedBox(height: 10), // Spacing between buttons
            // Tamil Button (reintroduced, functionality to be implemented later)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedLanguage = 'tamil';
                });
                // Placeholder for Tamil navigation (to be implemented later)
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => DashboardPage(),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedLanguage == 'tamil'
                    ? Color(0xFFFFE3AE)
                    : Color(0xFFEFEFEF), // Change color when selected
                foregroundColor: Color(0xFF191919), // Button text color
                minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 36), // Button height
              ),
              child: Text(
                'தமிழ்',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto', // Normal font instead of custom
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Event model to store event details
class Event {
  final String name;
  final String description;
  final DateTime startTime;

  Event({required this.name, required this.description, required this.startTime});
}

// Dashboard Page (Sinhala version only for now)
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Event> events;
  Event? selectedEvent;
  Timer? timer;
  Duration timeUntilNextEvent = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Sample events (5 demo events in Sinhala)
    events = [
      Event(
        name: 'නව වසර උදාව',
        description: 'අලුත් අවුරුද්ද උදාවන මොහොත.',
        startTime: DateTime.now().add(Duration(days: 1, hours: 2, minutes: 34, seconds: 12)),
      ),
      Event(
        name: 'අවුරුදු උත්සවය',
        description: 'අවුරුදු උත්සවය සමරමු.',
        startTime: DateTime.now().add(Duration(days: 2)),
      ),
      Event(
        name: 'සුභ නැකත',
        description: 'සුභ නැකතකින් ආරම්භය.',
        startTime: DateTime.now().add(Duration(days: 3)),
      ),
      Event(
        name: 'කිරි ඉතිරීම',
        description: 'කිරි ඉතිරීමේ චාරිත්‍රය.',
        startTime: DateTime.now().add(Duration(days: 4)),
      ),
      Event(
        name: 'අවුරුදු තෑගි',
        description: 'අවුරුදු තෑගි හුවමාරුව.',
        startTime: DateTime.now().add(Duration(days: 5)),
      ),
    ];

    // Auto-select the event with the nearest start time
    selectNearestEvent();

    // Start a timer to update the countdown every second
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (selectedEvent != null) {
          timeUntilNextEvent = selectedEvent!.startTime.difference(DateTime.now());
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
        selectedEvent = events.firstWhere(
          (event) => event.startTime.isAfter(DateTime.now()),
          orElse: () => events.first,
        );
        timeUntilNextEvent = selectedEvent!.startTime.difference(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estimate the height of the top section and first card
    const double topSectionHeight = 60.0; // Approximate height of "සුභ අළුත් අවුරුද්දක් වේවා!" + padding
    const double firstCardHeight = 150.0; // Approximate height of the first card (adjust based on content)
    const double spacingHeight = 20.0 + 10.0; // Space between first and second card + space below title
    const double secondCardTitleHeight = 40.0; // Approximate height of "නැකත් ලැයිස්තුව" title
    const double bottomGapHeight = 16.0; // Match the bottom gap with left and right padding (16.0)

    // Calculate the remaining height for the second card
    double remainingHeight = MediaQuery.of(context).size.height -
        topSectionHeight -
        firstCardHeight -
        spacingHeight -
        secondCardTitleHeight -
        bottomGapHeight -
        MediaQuery.of(context).padding.top; // Account for status bar height

    return Scaffold(
      backgroundColor: Color(0xFFF5C15C), // Background color
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Title and Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width - 32, // Match the width of the first card
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'සුභ අළුත් අවුරුද්දක් වේවා!',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFF191919),
                        fontFamily: 'UNDisapamok',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.translate, color: Color(0xFF191919)),
                          onPressed: () {
                            // Add language change logic later
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.notifications, color: Color(0xFF191919)),
                          onPressed: () {
                            // Add notification logic here
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Remove SingleChildScrollView and use Expanded to fill the remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Left and right padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Card: Next Event (Fixed, Non-Scrollable)
                    Container(
                      width: MediaQuery.of(context).size.width, // Set to device width
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event name on the same line as "මීළග නැකත :"
                          Text(
                            'මීළග නැකත : ${selectedEvent?.name ?? ''}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF191919),
                              fontFamily: 'UNArundathee',
                            ),
                          ),
                          SizedBox(height: 8),
                          // Countdown Timer (only time values have background color)
                          Container(
                            width: MediaQuery.of(context).size.width - 32, // Device width minus padding
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'දින: ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF191919),
                                        fontFamily: 'UNGurulugomi',
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE3AE),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '${timeUntilNextEvent.inDays}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF191919),
                                          fontFamily: 'UNGurulugomi',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'පැය: ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF191919),
                                        fontFamily: 'UNGurulugomi',
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE3AE),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '${(timeUntilNextEvent.inHours % 24).toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF191919),
                                          fontFamily: 'UNGurulugomi',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'මිනි: ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF191919),
                                        fontFamily: 'UNGurulugomi',
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE3AE),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '${(timeUntilNextEvent.inMinutes % 60).toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF191919),
                                          fontFamily: 'UNGurulugomi',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'තත්: ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF191919),
                                        fontFamily: 'UNGurulugomi',
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE3AE),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        '${(timeUntilNextEvent.inSeconds % 60).toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF191919),
                                          fontFamily: 'UNGurulugomi',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            selectedEvent?.description ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF191919),
                              fontFamily: 'UNGurulugomi',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Second Card: Event List Section (Fixed Container, Scrollable Event Cards)
                    Expanded( // Use Expanded to fill the remaining space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'නැකත් ලැයිස්තුව',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xFF191919),
                              fontFamily: 'UNDisapamok',
                            ),
                          ),
                          SizedBox(height: 10),
                          // Fixed Container for the Event List with remaining device height
                          Expanded( // Use Expanded to fill the remaining space for the ListView
                            child: Container(
                              width: MediaQuery.of(context).size.width, // Set to device width
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFEFEFEF),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  bool isSelected = event == selectedEvent;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedEvent = event;
                                        timeUntilNextEvent = event.startTime.difference(DateTime.now());
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 64, // Device width minus padding
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Color(0xFFFFCD71) : Color(0xFFFFE3AE),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF191919),
                                              fontFamily: 'UNArundathee',
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            event.description,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF191919),
                                              fontFamily: 'UNGurulugomi',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16), // Bottom gap matching left and right padding
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