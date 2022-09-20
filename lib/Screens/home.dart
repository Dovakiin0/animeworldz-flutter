// ignore_for_file: file_names
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Screens/loading.dart";
import "package:animeworldz_flutter/Widgets/card.dart";
import "package:http/http.dart" as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? title;

  Future<String> getAnime() async {
    return "hello";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAnime(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.done:
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Recent Release",
                          style: TextStyle(
                              fontSize: 22.0, fontFamily: "OpenSans")),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: const [
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Episode 1"),
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Episode 1"),
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Episode 1"),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      const Text("Popular Anime",
                          style: TextStyle(
                              fontSize: 22.0, fontFamily: "OpenSans")),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: const [
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Released 2022"),
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Released 2022"),
                          AnimeCard(
                              title: "Overlord IV",
                              image:
                                  "https://gogocdn.net/cover/overlord-iv.png",
                              additionalInfo: "Released 2022"),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return const Loading();
          }
        });
  }
}
