import 'package:animeworldz_flutter/Screens/loading.dart';
import 'package:animeworldz_flutter/Widgets/card.dart';
import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "package:animeworldz_flutter/Models/AnimeModel.dart";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _controller = TextEditingController();
  bool _loading = false;
  List<Anime> _animes = [];

  Future<void> getSearchAnime(String value) async {
    try {
      setState(() {
        _loading = true;
      });
      http.Response res = await http.get(
          Uri.parse("https://animeworldz.herokuapp.com/api/v1/anime/$value"));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        setState(() {
          _animes = data
              .map((e) => Anime(
                  title: e["title"],
                  additionalInfo: "Released: ${e['released']}",
                  img: e['img'],
                  link: e['link']))
              .toList();
          _loading = false;
        });
      } else {
        setState(() {
          _animes = [];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimeWorldzLayout(
        label: "Search",
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _controller,
              onFieldSubmitted: (value) {
                if (value != "") {
                  getSearchAnime(value);
                } else {
                  setState(() {
                    _animes = [];
                  });
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text("Search"),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _animes = [];
                      });
                    },
                  ),
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _animes.isNotEmpty
                      ? Wrap(
                          direction: Axis.horizontal,
                          spacing: 30.0,
                          children: _animes
                              .map<Widget>((e) => AnimeCard(
                                    title: e.title,
                                    image: e.img,
                                    link: e.link,
                                    additionalInfo: e.additionalInfo,
                                  ))
                              .toList())
                      : _loading
                          ? Center(child: const Loading())
                          : Container()),
            ),
          )
        ]));
  }
}
