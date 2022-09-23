import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import 'package:flutter/services.dart';
import "package:webview_flutter/webview_flutter.dart";
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "dart:io";

class WatchAnime extends StatefulWidget {
  const WatchAnime({super.key});

  @override
  State<WatchAnime> createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  Map args = {};
  WebViewController? _webView;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Future<AnimeEpisode?> getEpisode(args) async {
    try {
      Map reqBody = {};
      reqBody["ep"] = args["ep"];
      reqBody["slug"] = args["slug"];
      http.Response res = await http.post(
          Uri.parse("https://animeworldz.herokuapp.com/api/v1/anime/episode"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        List<dynamic> links = data['links'] ?? [];
        return AnimeEpisode(
          name: data["name"] ?? "N/A",
          episode: data['episode'] ?? 1,
          links: links,
        );
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    args = ModalRoute.of(context)!.settings.arguments as Map;
    return FutureBuilder(
      future: getEpisode(args),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Loading();
          case ConnectionState.done:
            AnimeEpisode data = snapshot.data as AnimeEpisode;
            String initialUri = data.links[0]["link"];
            return Column(
              children: [
                Expanded(
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    backgroundColor: Colors.black87,
                    allowsInlineMediaPlayback: true,
                    initialUrl: initialUri,
                    onWebViewCreated: (controller) => _webView = controller,
                    onPageFinished: (_) async {
                      try {
                        //
                        for (var i = 0; i < 10; i++) {
                          await _webView!.runJavascriptReturningResult(
                              "document.getElementsByTagName('iframe')[$i].style.display='none';");
                          await _webView!.runJavascriptReturningResult(
                              "document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].click();");
                        }
                        //
                        for (var i = 0; i < 8; i++) {
                          await _webView!.runJavascriptReturningResult(
                              "document.getElementsByTagName('iframe')[$i].style.display='none';");
                        }
                        await _webView!.runJavascriptReturningResult(
                            "document.getElementsByClassName('jw-icon jw-icon-inline jw-button-color jw-reset jw-icon-fullscreen')[1].click();");
                        await _webView!.runJavascriptReturningResult(
                            "if(document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].ariaLabel == 'Play'){document.getElementsByClassName('jw-icon jw-icon-display jw-button-color jw-reset')[0].click();}");
                        //
                        for (var i = 0; i < 8; i++) {
                          await _webView!.runJavascriptReturningResult(
                              "document.getElementsByTagName('iframe')[$i].style.display='none';");
                        }
                        await Future.delayed(const Duration(seconds: 1));
                        for (var i = 0; i < 10; i++) {
                          await _webView!.runJavascriptReturningResult(
                              "document.getElementsByTagName('iframe')[$i].style.display='none';");
                        }
                      } catch (e) {
                        print(
                            'An error occurred while parsing data from webView:');
                        print(e.toString());
                        rethrow;
                      }
                    },
                    navigationDelegate: (request) {
                      if (request.url == initialUri) {
                        return NavigationDecision.navigate;
                      }
                      return NavigationDecision.prevent;
                    },
                  ),
                ),
                // const SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "${data.name} |",
                //       style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.amber[700]),
                //     ),
                //     const SizedBox(width: 10),
                //     Text(
                //       "Episode: ${data.episode}",
                //       style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                // Column(
                //   children: [
                //     data.episode <= args['count']
                //         ? SizedBox(
                //             width: MediaQuery.of(context).size.width,
                //             child: Align(
                //               alignment: Alignment.centerRight,
                //               child: SizedBox(
                //                 width:
                //                     MediaQuery.of(context).size.width * 0.8,
                //                 child: ElevatedButton(
                //                   onPressed: () {
                //                     Navigator.popAndPushNamed(
                //                         context, "/watch",
                //                         arguments: {
                //                           "name": args["name"],
                //                           "slug": args["slug"],
                //                           "ep": data.episode + 1,
                //                           "count": args["count"]
                //                         });
                //                   },
                //                   style: ButtonStyle(
                //                     backgroundColor:
                //                         MaterialStateProperty.all(
                //                             Colors.amber[700]!),
                //                   ),
                //                   child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.end,
                //                       children: [
                //                         Text(
                //                             "Next: Episode ${data.episode + 1}",
                //                             style: TextStyle(fontSize: 15)),
                //                         SizedBox(width: 10),
                //                         Icon(Icons.arrow_forward),
                //                       ]),
                //                 ),
                //               ),
                //             ),
                //           )
                //         : Container(),
                //     args["ep"] > 1
                //         ? SizedBox(
                //             width: MediaQuery.of(context).size.width,
                //             child: Align(
                //               alignment: Alignment.centerLeft,
                //               child: SizedBox(
                //                 width:
                //                     MediaQuery.of(context).size.width * 0.8,
                //                 child: ElevatedButton(
                //                   onPressed: () {
                //                     Navigator.popAndPushNamed(
                //                         context, "/watch",
                //                         arguments: {
                //                           "name": args["name"],
                //                           "slug": args["slug"],
                //                           "ep": data.episode - 1,
                //                           "count": args["count"]
                //                         });
                //                   },
                //                   style: ButtonStyle(
                //                     backgroundColor:
                //                         MaterialStateProperty.all(
                //                             Colors.grey[700]!),
                //                   ),
                //                   child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         Icon(Icons.arrow_back),
                //                         SizedBox(width: 10),
                //                         Text(
                //                             "Previous: Episode ${data.episode - 1}",
                //                             style: TextStyle(fontSize: 15)),
                //                       ]),
                //                 ),
                //               ),
                //             ),
                //           )
                //         : Container(),
                //   ],
                // )
              ],
            );
          default:
            return Container();
        }
      },
    );
  }
}
