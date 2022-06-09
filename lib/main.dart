import 'package:flutter/material.dart';
import 'package:igps/screens/welcomePage.dart';
import 'package:igps/screens/activesPage.dart';
import 'package:igps/screens/notificationPage.dart';
import 'package:igps/screens/settingsPage.dart';

// Google maps API Key - AIzaSyBZOylElqUTJ2l69VN5sjTTkWRqRIysypU

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iGPS',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.blueGrey,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/actives': (context) => const ActivesPage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}