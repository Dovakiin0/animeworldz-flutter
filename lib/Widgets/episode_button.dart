import "package:flutter/material.dart";

class EpButton extends StatelessWidget {
  final int episode;
  final String slug;
  final String name;
  final int count;
  const EpButton(
      {super.key,
      required this.episode,
      required this.slug,
      required this.name,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, "/watch", arguments: {
          "slug": slug,
          "ep": episode,
          "name": name,
          "count": count
        });
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber[700])),
      child: Text(episode.toString()),
    );
  }
}
