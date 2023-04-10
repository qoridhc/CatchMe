import 'package:flutter/material.dart';
import 'dart:ui';

class CustomTextPainter extends StatelessWidget {
  final String text;

  const CustomTextPainter({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    return Container(
      width: textPainter.width + 13,
      height: textPainter.height + 13,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 7,
              color: Colors.grey.shade300,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
