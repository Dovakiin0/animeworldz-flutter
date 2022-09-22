import "package:flutter/material.dart";

class EpButton extends StatelessWidget {
  final String episode;
  final String slug;
  const EpButton({super.key, required this.episode, required this.slug});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/watch",
            arguments: {"slug": slug, "ep": episode});
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber[700])),
      child: Text(episode),
    );
  }
}
