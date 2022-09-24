import 'package:animeworldz_flutter/Screens/loading.dart';
import "package:flutter/material.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import "package:animeworldz_flutter/Models/AnimeModel.dart";
import "package:animeworldz_flutter/Widgets/card.dart";
import "package:intl/intl.dart";

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with TickerProviderStateMixin {
  String convertLocalTime(String date) {
    var dateValue =
        new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(date).toLocal();
    String formattedDate = DateFormat('hh:mm a').format(dateValue);
    return formattedDate;
  }

  Future<AnimeSchedule?> getSchedule() async {
    try {
      http.Response res = await http.post(
          Uri.parse("https://animeworldz.herokuapp.com/api/v1/schedule"),
          body: {"day": ""});
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        return AnimeSchedule(
          monday: data["monday"],
          tuesday: data["tuesday"],
          wednesday: data["wednesday"],
          thursday: data["thursday"],
          friday: data["friday"],
          saturday: data["saturday"],
          sunday: data["sunday"],
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
    TabController _tabController = TabController(length: 7, vsync: this);
    return FutureBuilder(
        future: getSchedule(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.done:
              AnimeSchedule? schedule = snapshot.data!;
              print(schedule.monday);
              return Column(
                children: [
                  TabBar(
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(color: Colors.amber[700]!, width: 2)),
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Monday"),
                        Tab(text: "Tuesday"),
                        Tab(text: "Wednesday"),
                        Tab(text: "Thursday"),
                        Tab(text: "Friday"),
                        Tab(text: "Saturday"),
                        Tab(text: "Sunday"),
                      ]),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.monday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.tuesday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.wednesday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.thursday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.friday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.saturday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 30,
                              children: schedule.sunday
                                  .map(
                                    (anime) => AnimeCard(
                                      title: anime["title"],
                                      additionalInfo: convertLocalTime(
                                          anime['airing_time']),
                                      image: anime['img'],
                                    ),
                                  )
                                  .toList()),
                        ),
                      ),
                    ]),
                  )
                ],
              );

            default:
              return Container();
          }
        });
  }
}
