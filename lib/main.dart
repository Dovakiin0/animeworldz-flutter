import 'package:animeworldz_flutter/Screens/web_view_external.dart';
import "package:flutter/material.dart";
import 'package:animeworldz_flutter/Screens/details.dart';
import 'package:animeworldz_flutter/Screens/search.dart';
import 'package:animeworldz_flutter/Screens/watch.dart';
import "package:animeworldz_flutter/theme/animeworldz_theme.dart";
import "animeworldzapp.dart";
import "package:flutter_downloader/flutter_downloader.dart";

void main() async {
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(MaterialApp(
    title: "AnimeWorld-Z",
    debugShowCheckedModeBanner: false,
    theme: animeWorldzTheme,
    initialRoute: "/",
    routes: {
      "/": (context) => const AnimeWorldzApp(),
      "/search": (context) => const Search(),
      "/detail": (context) => const Details(),
      "/watch": (context) => const WatchAnime(),
      "/external": (context) => const WebViewExternal()
    },
  ));
}
