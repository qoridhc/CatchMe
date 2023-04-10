import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String imgUrl;
  const DetailScreen({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: imgUrl,
          child: Center(
            child: Image.asset(imgUrl),
          ),
        ),
      ),
    );
  }
}
