import "package:flutter/material.dart";
import "package:animeworldz_flutter/theme/animeworldz_theme.dart";
import "package:animeworldz_flutter/Widgets/card.dart";

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
      appBar: AppBar(
        leading: const Image(image: AssetImage("assets/favicon.png")),
        centerTitle: true,
        title: const Text("ANIMEWORLD-Z",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Recent Release",
                style: TextStyle(fontSize: 22.0, fontFamily: "Nunito")),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: const [
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Episode 1"),
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Episode 1"),
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Episode 1"),
              ]),
            ),
            const SizedBox(height: 20),
            const Text("Popular Anime",
                style: TextStyle(fontSize: 22.0, fontFamily: "Nunito")),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: const [
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Released 2022"),
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Released 2022"),
                AnimeCard(
                    title: "Overlord IV",
                    image: "https://gogocdn.net/cover/overlord-iv.png",
                    additionalInfo: "Released 2022"),
              ]),
            ),
          ],
        ),
      ),
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
            icon: Icon(
                currentIndex == 3 ? Icons.settings : Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
