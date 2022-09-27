import "package:flutter/material.dart";
import 'package:animeworldz_flutter/Screens/favourite.dart';
import 'package:animeworldz_flutter/Screens/schedule.dart';
import 'package:animeworldz_flutter/Screens/settings.dart';
import "package:animeworldz_flutter/Screens/Home.dart";
import "package:animeworldz_flutter/Screens/waifu.dart";

class AnimeWorldzApp extends StatefulWidget {
  const AnimeWorldzApp({super.key});

  @override
  State<AnimeWorldzApp> createState() => _AnimeWorldzAppState();
}

class _AnimeWorldzAppState extends State<AnimeWorldzApp> {
  int currentIndex = 0;
  List<Widget> screens = [
    const Home(),
    const Favourite(),
    const Schedule(),
    const Waifu(),
    const Settings()
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Image(image: AssetImage("assets/favicon.png")),
        centerTitle: true,
        title: const Text("ANIMEWORLD-Z",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber[700],
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
            icon: Icon(currentIndex == 2
                ? Icons.watch_later
                : Icons.watch_later_outlined),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(currentIndex == 3 ? Icons.image : Icons.image_outlined),
            label: 'Waifu',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                currentIndex == 4 ? Icons.settings : Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
