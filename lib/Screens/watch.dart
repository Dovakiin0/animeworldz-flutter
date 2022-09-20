import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";

class WatchAnime extends StatefulWidget {
  const WatchAnime({super.key});

  @override
  State<WatchAnime> createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  @override
  Widget build(BuildContext context) {
    return AnimeWorldzLayout(label: "Watch", child: const Text("Watch"));
  }
}
