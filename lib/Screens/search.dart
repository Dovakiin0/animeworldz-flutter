import "package:flutter/material.dart";
import "package:animeworldz_flutter/Layouts/layout.dart";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return AnimeWorldzLayout(
        label: "Search",
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text("Search"),
                  prefixIcon: Icon(Icons.search)),
            ),
          )
        ]));
  }
}
