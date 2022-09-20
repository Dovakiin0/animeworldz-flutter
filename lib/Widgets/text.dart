import "package:flutter/material.dart";

class AnimeWorldzText extends StatelessWidget {
  final String text;
  final double size;
  const AnimeWorldzText({super.key, required this.text, this.size = 15});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: size));
  }
}
