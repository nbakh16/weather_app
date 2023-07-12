import 'package:flutter/material.dart';
import 'package:weather_app/view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeView()
    );
  }
}