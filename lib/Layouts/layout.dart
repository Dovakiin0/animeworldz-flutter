import "package:flutter/material.dart";

class AnimeWorldzLayout extends StatelessWidget {
  final Widget child;
  final String label;

  const AnimeWorldzLayout(
      {super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ),
      body: child,
    );
  }
}
