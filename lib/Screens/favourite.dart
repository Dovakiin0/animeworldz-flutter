import 'package:animeworldz_flutter/Models/AnimeModel.dart';
import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "dart:convert";
import "package:animeworldz_flutter/Widgets/card.dart";

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  Future<List<Anime>> getFavourites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Anime> animes = [];
    prefs.getKeys().forEach((key) {
      if (key == "watched") return;
      Map<String, dynamic> fav = jsonDecode(prefs.getString(key).toString());
      animes.add(Anime(
          title: fav["title"],
          additionalInfo: fav["released"],
          img: fav["img"],
          link: fav["link"]));
    });
    return animes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFavourites(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loading();
          case ConnectionState.done:
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                      direction: Axis.horizontal,
                      spacing: 30,
                      children: snapshot.data!
                          .map<Widget>(
                            (anime) => AnimeCard(
                              title: anime.title,
                              additionalInfo:
                                  "Released: " + anime.additionalInfo,
                              image: anime.img,
                              link: anime.link,
                            ),
                          )
                          .toList()),
                ],
              ),
            );
          default:
            return Container();
        }
      }),
    );
  }
}
