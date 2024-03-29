import 'dart:ui';
import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:animeworldz_flutter/Widgets/episode_button.dart";
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import "package:animeworldz_flutter/Helper/constant.dart";

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map args = {};
  bool _isFavourite = false;
  List<dynamic> watched_eps = [];

  Future<AnimeInfo?> getAnimeDetails(arg) async {
    try {
      http.Response res =
          await http.get(Uri.parse(API_URI + "/info/${arg['link']}"));
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        AnimeInfo animeInfo = AnimeInfo.fromJson(data);
        return animeInfo;
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
      return null;
    }
    return null;
  }

  void toggleFavourite(AnimeInfo details) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(details.title)) {
        prefs.remove(details.title);
        setState(() {
          _isFavourite = false;
        });
      } else {
        prefs.setString(
            details.title,
            jsonEncode({
              "title": details.title,
              "link": details.id,
              "img": details.image,
              "released": details.releaseDate,
            }).toString());
        setState(() {
          _isFavourite = true;
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    }
  }

  Future<bool> checkPrefs(args) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("watched")) {
        Map watched = jsonDecode(prefs.getString("watched")!);
        if (watched.containsKey(args["name"])) {
          watched_eps = watched[args["name"]];
        }
      }
      if (prefs.containsKey(args["name"])) {
        _isFavourite = true;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void epCallback(String slug, int episode, String name, int count) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey("watched")) {
        Map data = jsonDecode(prefs.getString("watched")!);
        if (data.containsKey(args["name"])) {
          List<dynamic> watched = data[args["name"]];
          var contain = watched.where((element) => element == episode);
          if (contain.isEmpty) {
            watched.add(episode);
          }
          data[args["name"]] = watched;
          prefs.setString("watched", jsonEncode(data).toString());
        } else {
          prefs.setString(
              "watched",
              jsonEncode({
                args["name"]: [episode],
                ...data,
              }).toString());
        }
      } else {
        prefs.setString(
            "watched",
            jsonEncode({
              args["name"]: [episode]
            }).toString());
      }
      Navigator.pushNamed(context, "/watch", arguments: {
        "slug": slug,
        "ep": episode,
        "name": name,
        "count": count
      }).whenComplete(() => setState(() => {}));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;
    return AnimeWorldzLayout(
        label: args['name'],
        child: FutureBuilder(
          future: Future.wait([checkPrefs(args), getAnimeDetails(args)]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loading();
              case ConnectionState.done:
                AnimeInfo data = snapshot.data![1] as AnimeInfo;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.dstATop),
                          image: NetworkImage(data.image),
                          fit: BoxFit.cover)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data.image,
                                  height: 200,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 190,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.title,
                                        maxLines: 3,
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    Text(data.otherName,
                                        maxLines: 3,
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 15.0)),
                                    const SizedBox(height: 10),
                                    Text("Status: ${data.status}",
                                        maxLines: 3,
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 15.0)),
                                    const SizedBox(height: 10),
                                    Text("Released: ${data.releaseDate}",
                                        maxLines: 3,
                                        softWrap: true,
                                        style: const TextStyle(fontSize: 15.0)),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              toggleFavourite(data);
                                            },
                                            icon: Icon(
                                              _isFavourite
                                                  ? Icons.favorite
                                                  : Icons
                                                      .favorite_border_outlined,
                                              color: Colors.amber[700],
                                            )),
                                        Text(_isFavourite
                                            ? "Remove From Favourite"
                                            : "Add To Favourite")
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                      spacing: 5.0,
                                      direction: Axis.horizontal,
                                      children: data.genres
                                          .map((e) => Chip(
                                                label: Text(e,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                backgroundColor:
                                                    Colors.amber[700],
                                              ))
                                          .toList()),
                                  const SizedBox(height: 10),
                                  Text("Plot Summary",
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 150,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(data.description,
                                          style:
                                              const TextStyle(fontSize: 15.0)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text("Episodes",
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10.0,
                                    children: [
                                      for (int i = data.totalEpisodes;
                                          i >= 1;
                                          i--)
                                        EpButton(
                                          episode: i,
                                          slug: data.episodes[i - 1]["id"],
                                          name: data.title,
                                          count: data.totalEpisodes,
                                          callback: epCallback,
                                          watched: watched_eps.contains(i),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              default:
                return Container();
            }
          },
        ));
  }
}
