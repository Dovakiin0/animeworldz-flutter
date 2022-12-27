import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import "package:chewie/chewie.dart";
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Helper/constant.dart";
import "dart:convert";
import "dart:io";

class WatchAnime extends StatefulWidget {
  const WatchAnime({super.key});

  @override
  State<WatchAnime> createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  Map args = {};
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
  }

  Future<List<EpisodeSources>> getEpisode(args) async {
    try {
      Map reqBody = {};
      reqBody["ep"] = args["ep"];
      reqBody["slug"] = args["slug"];
      http.Response res = await http
          .get(Uri.parse(API_URI + "/watch/${args["slug"]}?server=gogocdn"));
      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        List<EpisodeSources> sources = data["sources"]
            .map<EpisodeSources>((e) => EpisodeSources.fromJson(e))
            .toList();
        return sources;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  void _initPlayer(String currentSource) async {
    videoPlayerController = VideoPlayerController.network(currentSource);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      showControls: true,
      showControlsOnInitialize: true,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.amber[700],
      //   handleColor: Colors.amber[700],
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.amber[700],
      // ),
      placeholder: const Center(
        child: Loading(),
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
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
              List<EpisodeSources> data = snapshot.data as List<EpisodeSources>;
              String currentSource = data[0].url;
              _initPlayer(currentSource);
              return Column(
                children: [
                  Expanded(
                    child: chewieController == null
                        ? const Loading()
                        : SizedBox(
                            child: Chewie(
                              controller: chewieController!,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${args["name"]} |",
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
