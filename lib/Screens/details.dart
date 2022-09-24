import 'dart:ui';
import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:animeworldz_flutter/Widgets/episode_button.dart";
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Map args = {};
  bool _isFavourite = false;

  Future<AnimeDetail?> getAnimeDetails(arg) async {
    try {
      http.Response res = await http.post(
          Uri.parse("https://animeworldz.herokuapp.com/api/v1/anime"),
          body: {"uri": arg["link"]});
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        List<dynamic> genres = data['genre'] ?? [];
        return AnimeDetail(
          img: data["img"] ?? "https://s1.zerochan.net/Index.600.1156386.jpg",
          title: data["title"] ?? "N/A",
          slug: data["slug"] ?? "N/A",
          type: data["type"] ?? "N/A",
          plotSummary: data["plot_summary"] ?? "N/A",
          genres: genres,
          released: data["released"] ?? "N/A",
          status: data["status"] ?? "N/A",
          otherName: data["other_name"] ?? "N/A",
          episodesCount: data["episode_count"] ?? "N/A",
        );
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

  void toggleFavourite(AnimeDetail details) async {
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
              "link": "/category/${details.slug}",
              "img": details.img,
              "released": details.released,
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

  Future<bool> checkFavourite(args) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getKeys());
      if (prefs.containsKey(args["name"])) {
        _isFavourite = true;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;
    return AnimeWorldzLayout(
        label: args['name'],
        child: FutureBuilder(
          future: Future.wait([checkFavourite(args), getAnimeDetails(args)]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loading();
              case ConnectionState.done:
                AnimeDetail data = snapshot.data![1] as AnimeDetail;
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.dstATop),
                          image: NetworkImage(data.img),
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
                                  data.img,
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
                                    Text("Released: ${data.released}",
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
                                      child: Text(data.plotSummary,
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
                                      for (int i =
                                              int.parse(data.episodesCount);
                                          i >= 1;
                                          i--)
                                        EpButton(
                                            episode: i,
                                            slug: data.slug,
                                            name: data.title,
                                            count:
                                                int.parse(data.episodesCount)),
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
