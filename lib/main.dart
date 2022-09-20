import "package:flutter/material.dart";
import "package:animeworldz_flutter/theme/animeworldz_theme.dart";
import 'package:animeworldz_flutter/Widgets/text.dart';

void main() {
  runApp(MaterialApp(
      title: "AnimeWorldZ",
      debugShowCheckedModeBanner: false,
      theme: animeWorldzTheme,
      home: const AnimeWorldzApp()));
}

class AnimeWorldzApp extends StatefulWidget {
  const AnimeWorldzApp({super.key});

  @override
  State<AnimeWorldzApp> createState() => _AnimeWorldzAppState();
}

class _AnimeWorldzAppState extends State<AnimeWorldzApp> {
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: const Image(image: AssetImage("assets/favicon.png")),
        title: const Text("ANIMEWORLD-Z",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: AnimeWorldzText(text: "Hello World"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        onTap: (value) => onTap(value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 0 ? Icons.home_filled : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 1 ? Icons.favorite : Icons.favorite_outline),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 2 ? Icons.settings : Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
