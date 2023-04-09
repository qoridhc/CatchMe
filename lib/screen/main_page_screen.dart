import 'package:captone4/widget/default_layout.dart';
import 'package:flutter/material.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({Key? key}) : super(key: key);

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Main",
      child: Center(
        child: Text("Main Page Screen"),
      ),
    );
  }
}
