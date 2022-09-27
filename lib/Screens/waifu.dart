import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "package:masonry_grid/masonry_grid.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";

class Waifu extends StatefulWidget {
  const Waifu({super.key});

  @override
  State<Waifu> createState() => _WaifuState();
}

class _WaifuState extends State<Waifu> {
  List images = [];
  final List<String> waifu_filter = [
    "Waifu",
    "Neko",
    "Megumin",
    "Cuddle",
    "Pat",
    "Slap"
  ];
  final List<String> waifu_type = ["SFW", "NSFW"];
  String filter = "waifu";
  String type = "sfw";
  var status;

  Future getWaifuImages({String waifu = "waifu", String type = "sfw"}) async {
    try {
      http.Response res = await http.post(
          Uri.parse("https://api.waifu.pics/many/$type/$waifu"),
          body: {"": ""});
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body)['files'];
        setState(() {
          images = data;
        });
      }
      setState(() {
        status = res.statusCode;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getWaifuImages();
  }

  @override
  Widget build(BuildContext context) {
    return images.isEmpty
        ? status == 404
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.asset("assets/pervert-anime.gif"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Select Waifu, if you are looking for NSFW",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            images = [];
                          });
                          getWaifuImages();
                        },
                        child: Text("Click to reset fields",
                            style: TextStyle(color: Colors.amber[700])),
                      ),
                    ]),
              )
            : const Loading()
        : AnimeWorldzFAB(
            onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      title: const Text("Filters"),
                      content: SizedBox(
                        height: 200,
                        child: StatefulBuilder(
                          builder: ((context, setState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Waifu Type",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.amber[700],
                                  ),
                                  value: filter,
                                  items: waifu_filter
                                      .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e.toLowerCase()))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      filter = value.toString();
                                    });
                                  },
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "SFW / NSFW",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  underline: Container(
                                    height: 1,
                                    color: Colors.amber[700],
                                  ),
                                  value: type,
                                  items: waifu_type
                                      .map((e) => DropdownMenuItem(
                                          child: Text(e),
                                          value: e.toLowerCase()))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      type = value.toString();
                                    });
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              getWaifuImages(waifu: filter, type: type);
                              setState(() {
                                images = [];
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Filter",
                              style: TextStyle(color: Colors.amber[700]),
                            )),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Close",
                              style: TextStyle(color: Colors.grey[600]),
                            )),
                      ],
                    )),
            child: RefreshIndicator(
              color: Colors.amber,
              strokeWidth: 4.0,
              onRefresh: getWaifuImages,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: MasonryGrid(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    column: 2,
                    children: images
                        .map(
                          (e) => ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.network(e)),
                        )
                        .toList(),
                  )),
            ),
          );
  }
}
