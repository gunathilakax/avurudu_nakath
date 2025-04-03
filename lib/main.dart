import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/home_page.dart';

// Constants for maintainability
const String kAppTitle = 'Avurudu Nakath';
const String kLocale = 'si';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(kLocale, null); // Initialize Sinhala locale
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'UNDisapamok',
      ),
      home: const HomePage(),
    );
  }
}