import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
// import 'package:video_player/video_player.dart';
// import "package:chewie/chewie.dart";
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Helper/constant.dart";
import "dart:convert";
import "package:flutter_vlc_player/flutter_vlc_player.dart";

class WatchAnime extends StatefulWidget {
  const WatchAnime({super.key});

  @override
  State<WatchAnime> createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  Map args = {};
  // late VideoPlayerController videoPlayerController;
  // ChewieController? chewieController;
  late String currentSource;
  VlcPlayerController? _videoViewController;

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
        currentSource = sources[0].url;
        await _initPlayer(currentSource);
        return sources;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> _initPlayer(String currentSource) async {
    // videoPlayerController = VideoPlayerController.network(
    //     "https://wwwx16.gofcdn.com/videos/hls/7ijsY8JlZk-qqw95i2P8NA/1672162453/193235/7c84129bc367b093eef803077c63241b/ep.36.1666964540.1080.m3u8");
    // await Future.wait([
    //   videoPlayerController.initialize(),
    // ]);
    // chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   aspectRatio: 16 / 9,
    //   autoPlay: true,
    //   looping: false,
    //   allowFullScreen: true,
    //   allowMuting: true,
    //   // allowPlaybackSpeedChanging: true,
    //   showControls: true,
    //   showControlsOnInitialize: true,
    //   materialProgressColors: ChewieProgressColors(
    //     playedColor: Colors.amber,
    //     handleColor: Colors.amber,
    //     backgroundColor: Colors.grey,
    //     bufferedColor: Colors.amber,
    //   ),
    // );
    _videoViewController = VlcPlayerController.network(currentSource,
        hwAcc: HwAcc.auto, autoPlay: true, options: VlcPlayerOptions());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _videoViewController!.stopRendererScanning();
    _videoViewController!.dispose();
    // videoPlayerController.dispose();
    // chewieController?.dispose();
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
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: _videoViewController != null
                          ? VlcPlayer(
                              controller: _videoViewController!,
                              aspectRatio: 16 / 9,
                            )
                          : const Loading()),
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 0.3,
                  //     child: chewieController != null
                  //         ? Chewie(
                  //             controller: chewieController!,
                  //           )
                  //         : const Loading()),

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
