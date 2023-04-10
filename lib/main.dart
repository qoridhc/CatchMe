import 'package:captone4/models/color_scheme.dart';
import 'package:captone4/screens/swipe_card.dart';
import 'package:captone4/screens/swipe.dart';
import 'package:captone4/layout/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catch Me',
      theme: lightThemeDataCustom,
      home: Scaffold(
        extendBodyBehindAppBar: true, // AppBar 뒤쪽에 화면 보일 수 있게 함.
        // body: const Text('Main Page'),
        body: Swipe(),
      ),
    );
  }
}