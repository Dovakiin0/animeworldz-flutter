// ignore_for_file: file_names
import 'dart:isolate';
import 'dart:ui';
import "dart:io";
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Screens/loading.dart";
import "package:animeworldz_flutter/Widgets/card.dart";
import 'package:flutter/services.dart';
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:flutter_downloader/flutter_downloader.dart";
import "dart:convert";
import "package:path_provider/path_provider.dart";
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future downloadUpdate(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final savePath = baseStorage!.path + "/AnimeWorldz.apk";
      if (await File(savePath).exists()) {
        await File(savePath).delete();
      }
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: baseStorage.path,
        fileName: "AnimeWorldz.apk",
        showNotification: true,
        openFileFromNotification: true,
      );
      SystemNavigator.pop();
    }
  }

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
                link: e['href']))
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

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
      // int progress = data[2];

      // setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void checkForUpdate(context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = '${packageInfo.version}+${packageInfo.buildNumber}';
      http.Response res = await http.get(Uri.parse(
          "https://raw.githubusercontent.com/Dovakiin0/animeworldz-mobile/master/current_version.json"));
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        if (data["current_version"] != version) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "New update available! Version ${data["current_version"]}",
                style: TextStyle(color: Colors.white)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.amber[700],
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: "Update",
              textColor: Colors.white,
              onPressed: () async {
                await downloadUpdate(data['release']);
              },
            ),
          ));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    checkForUpdate(context);
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
                                        link: e.link,
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
                                        link: e.link,
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
