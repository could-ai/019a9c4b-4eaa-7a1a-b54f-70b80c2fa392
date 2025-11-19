import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/video_landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Landing Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Dark theme suits video backgrounds better
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Using default font, but styled nicely
      ),
      home: const VideoLandingPage(),
    );
  }
}
