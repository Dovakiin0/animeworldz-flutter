import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:package_info_plus/package_info_plus.dart";
// import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void setPreferredQuality(String quality) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("pref_quality", quality);
  }

  String version = "";

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

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
                  "uri": "https://discordapp.com/users/388546055098073090"
                });
              },
              icon: FaIcon(FontAwesomeIcons.discord),
              iconSize: 30,
            ),
          ],
        ),
        const SizedBox(height: 100),
        Text("Version: ${version}", style: TextStyle(fontSize: 18.0)),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const SizedBox(width: 20),
        //     Text("Preferred quality: ",
        //         style: TextStyle(
        //             fontSize: 17.0,
        //             fontFamily: "OpenSans",
        //             color: Colors.grey[300])),
        //     const SizedBox(width: 20),
        //     DropdownButton<String>(
        //       value: "1080p",
        //       icon: const Icon(Icons.arrow_downward),
        //       iconSize: 24,
        //       elevation: 16,
        //       style: TextStyle(color: Colors.grey[300]),
        //       underline: Container(
        //         height: 2,
        //         color: Colors.grey[300],
        //       ),
        //       onChanged: (String? newValue) {
        //         setPreferredQuality(newValue!);
        //       },
        //       items: <String>['1080p', '720p', '480p', '360p']
        //           .map<DropdownMenuItem<String>>((String value) {
        //         return DropdownMenuItem<String>(
        //           value: value,
        //           child: Text(value,
        //               style: TextStyle(
        //                   fontSize: 15.0,
        //                   fontFamily: "OpenSans",
        //                   color: Colors.grey[300])),
        //         );
        //       }).toList(),
        //     ),
        //   ],
        // ),
      ],
    ));
  }
}
