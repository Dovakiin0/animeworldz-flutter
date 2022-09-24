import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("SETTINGS", style: TextStyle(fontSize: 18.0)),
        const SizedBox(height: 90),
        CircleAvatar(
          backgroundImage: AssetImage("assets/pp.jpeg"),
          radius: 70,
        ),
        const SizedBox(height: 10),
        Text(
          "Created By: Dovakiin0",
          style: TextStyle(
              fontSize: 17.0, fontFamily: "OpenSans", color: Colors.grey[300]),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/external",
                    arguments: {"uri": "https://github.com/Dovakiin0"});
              },
              icon: FaIcon(FontAwesomeIcons.github),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/external", arguments: {
                  "uri": "https://www.instagram.com/dovakiin0._/"
                });
              },
              icon: FaIcon(FontAwesomeIcons.instagram),
              iconSize: 30,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/external", arguments: {
                  "uri": "https://discord.com/invite/RNADXBTvcx"
                });
              },
              icon: FaIcon(FontAwesomeIcons.discord),
              iconSize: 30,
            ),
          ],
        ),
        const SizedBox(height: 100),
        Text(
          "Features coming soon!!",
          style: TextStyle(
              fontSize: 17.0, fontFamily: "OpenSans", color: Colors.grey[300]),
        ),
      ],
    ));
  }
}
