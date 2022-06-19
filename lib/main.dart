import 'package:flutter/material.dart';
import 'package:igps/screens/welcome_page.dart';
import 'package:igps/screens/actives_page.dart';
import 'package:igps/screens/notification_page.dart';
import 'package:igps/screens/settings_page.dart';

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
        '/assets': (context) => const AssetsPage(),
        '/notification': (context) => const NotificationPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}