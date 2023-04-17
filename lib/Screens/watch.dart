import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Helper/constant.dart";
import "dart:convert";
import 'package:fijkplayer/fijkplayer.dart';

class WatchAnime extends StatefulWidget {
  const WatchAnime({super.key});

  @override
  State<WatchAnime> createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  Map args = {};
  late EpisodeSources currentSource;
  final FijkPlayer _player = FijkPlayer();

  Future<List<EpisodeSources>> getEpisode(args) async {
    try {
      Map reqBody = {};
      reqBody["ep"] = args["ep"];
      reqBody["slug"] = args["slug"];
      http.Response res = await http.get(
          Uri.parse(API_URI + "/watch/${args["slug"]}?server=vidstreaming"));
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        List<EpisodeSources> sources = data["sources"]
            .map<EpisodeSources>((e) => EpisodeSources.fromJson(e))
            .toList();

        for (EpisodeSources source in sources) {
          if (source.quality == "1080p") {
            currentSource = source;
            break;
          } else {
            currentSource = sources[0];
          }
        }
        _updatePlayerSource(currentSource);
        return sources;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _updatePlayerSource(EpisodeSources currentSource) {
    _player.setDataSource(currentSource.url, autoPlay: true);
  }

  @override
  void dispose() {
    if (_player.state == FijkState.asyncPreparing) {
      _player.stop();
    }
    _player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map;

    return AnimeWorldzLayout(
      label: "Watch " + args["name"],
      child: FutureBuilder(
        future: getEpisode(args),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.done:
              // List<EpisodeSources> data = snapshot.data as List<EpisodeSources>;
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: FijkView(
                      player: _player,
                      color: Colors.black,
                      onDispose: (p0) => _player.release(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "${args["name"]} |",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700]),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Episode: ${args["ep"]}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // DropdownButton(
                  //   icon: const Icon(Icons.arrow_downward),
                  //   items: data
                  //       .map((e) => DropdownMenuItem(
                  //             child: Text(e.quality),
                  //             value: e,
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     currentSource = value as EpisodeSources;
                  //     _updatePlayerSource(currentSource);
                  //   },
                  // ),
                  // const SizedBox(height: 20),
                  Column(
                    children: [
                      args["ep"] <= args['count']
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, "/watch",
                                          arguments: {
                                            "name": args["name"],
                                            "slug": args["slug"],
                                            "ep": args["ep"] + 1,
                                            "count": args["count"]
                                          });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.amber[700]!),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              "Next: Episode ${args["ep"] + 1}",
                                              style: TextStyle(fontSize: 15)),
                                          SizedBox(width: 10),
                                          Icon(Icons.arrow_forward),
                                        ]),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      args["ep"] > 1
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, "/watch",
                                          arguments: {
                                            "name": args["name"],
                                            "slug": args["slug"],
                                            "ep": args["ep"] - 1,
                                            "count": args["count"]
                                          });
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey[700]!),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.arrow_back),
                                          SizedBox(width: 10),
                                          Text(
                                              "Previous: Episode ${args["ep"] - 1}",
                                              style: TextStyle(fontSize: 15)),
                                        ]),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )
                ],
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
