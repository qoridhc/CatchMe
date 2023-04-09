import 'package:flutter/material.dart';

import '../widget/default_layout.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Favorite",
      child: Center(
        child: Text("Favorite Page Screen"),
      ),
    );
  }
}
