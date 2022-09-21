import "package:flutter/material.dart";
import 'package:animeworldz_flutter/Screens/details.dart';
import 'package:animeworldz_flutter/Screens/search.dart';
import 'package:animeworldz_flutter/Screens/watch.dart';
import "package:animeworldz_flutter/theme/animeworldz_theme.dart";
import "animeworldzapp.dart";

void main() {
  runApp(MaterialApp(
    title: "AnimeWorld-Z",
    debugShowCheckedModeBanner: false,
    theme: animeWorldzTheme,
    initialRoute: "/",
    routes: {
      "/": (context) => const AnimeWorldzApp(),
      "/search": (context) => const Search(),
      "/detail": (context) => const Details(),
      "/watch": (context) => const WatchAnime()
    },
  ));
}
