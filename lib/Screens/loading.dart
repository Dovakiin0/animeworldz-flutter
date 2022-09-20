import "package:flutter/material.dart";

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/genkai.gif",
        height: 100,
        width: 100,
      ),
    );
  }
}
