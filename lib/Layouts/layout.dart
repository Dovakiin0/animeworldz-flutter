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

class AnimeWorldzFAB extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  const AnimeWorldzFAB(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[700],
        onPressed: () {
          onPressed();
        },
        child: Icon(
          Icons.filter_alt_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
