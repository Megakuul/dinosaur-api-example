import 'package:flutter/material.dart';


class AdvText extends StatefulWidget {
  const AdvText({required this.gradient, required this.text, required this.fontSize, required this.fontWeight});

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final LinearGradient gradient;


  @override
  State<AdvText> createState() => _AdvTextState();
}

class _AdvTextState extends State<AdvText> {

  @override
  Widget build(BuildContext context) {
    return Text(widget.text,
        style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            foreground: Paint()..shader = widget.gradient.createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
        )
    );
  }
}