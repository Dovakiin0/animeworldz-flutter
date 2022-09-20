import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return AnimeWorldzLayout(label: "Anime Name", child: const Text("Details"));
  }
}
