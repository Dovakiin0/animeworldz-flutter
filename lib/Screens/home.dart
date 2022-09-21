// ignore_for_file: file_names
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Screens/loading.dart";
import "package:animeworldz_flutter/Widgets/card.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "dart:convert";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Anime>> getRecentAnime() async {
    try {
      http.Response res = await http.get(
          Uri.parse("https://animeworldz.herokuapp.com/api/v1/anime/recent/1"));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        return data
            .map((e) => Anime(
                title: e["name"],
                additionalInfo: e['recent_episode'],
                img: e['img'],
                link: e['link']))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<Anime>> getPopularAnime() async {
    try {
      http.Response res = await http.get(Uri.parse(
          "https://animeworldz.herokuapp.com/api/v1/anime/popular/1"));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        return data
            .map((e) => Anime(
                title: e["name"],
                additionalInfo: e['release'],
                img: e['img'],
                link: e['link']))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getRecentAnime(), getPopularAnime()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.done:
              List recent = snapshot.data![0];
              List popular = snapshot.data![1];
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
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.hasData
                                ? recent
                                    .map<Widget>((e) => AnimeCard(
                                        title: e.title,
                                        image: e.img,
                                        additionalInfo: e.additionalInfo))
                                    .toList()
                                : []),
                      ),
                      const SizedBox(height: 20),
                      const Text("Popular Anime",
                          style: TextStyle(
                              fontSize: 22.0, fontFamily: "OpenSans")),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: snapshot.hasData
                                ? popular
                                    .map<Widget>((e) => AnimeCard(
                                        title: e.title,
                                        image: e.img,
                                        additionalInfo: e.additionalInfo))
                                    .toList()
                                : []),
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
