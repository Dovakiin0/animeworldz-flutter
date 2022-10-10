import "package:flutter/material.dart";

class EpButton extends StatelessWidget {
  final int episode;
  final String slug;
  final String name;
  final int count;
  final Function(String, int, String, int) callback;
  final bool watched;

  const EpButton({
    super.key,
    required this.episode,
    required this.slug,
    required this.name,
    required this.count,
    required this.watched,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        callback(slug, episode, name, count);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              watched ? Colors.grey[500] : Colors.amber[700])),
      child: Text(
        episode.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/*
watched: {
  "title-anime": [0,1,2,3]
}

*/