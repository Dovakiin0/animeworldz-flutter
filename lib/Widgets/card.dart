import "package:flutter/material.dart";

class AnimeCard extends StatelessWidget {
  final String title;
  final String image;
  final String additionalInfo;

  const AnimeCard(
      {super.key,
      required this.title,
      required this.image,
      required this.additionalInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  children: [
                    Image.network(
                      image,
                      height: 180,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 0, 2.5),
                        child: Text(
                          additionalInfo,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
