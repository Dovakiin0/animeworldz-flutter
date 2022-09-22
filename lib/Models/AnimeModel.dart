// ignore_for_file: file_names

class Anime {
  final String title;
  final String img;
  final String link;
  final String additionalInfo;

  Anime(
      {required this.title,
      required this.img,
      required this.link,
      required this.additionalInfo});
}

class AnimeDetail {
  final String title;
  final String img;
  final String released;
  final String plotSummary;
  final List<dynamic> genres;
  final String episodesCount;
  final String type;
  final String slug;
  final String otherName;
  final String status;

  AnimeDetail(
      {required this.title,
      required this.img,
      required this.released,
      required this.plotSummary,
      required this.genres,
      required this.episodesCount,
      required this.type,
      required this.slug,
      required this.otherName,
      required this.status});
}

class AnimeEpisode {
  final String name;
  final int episode;
  final List<dynamic> links;

  AnimeEpisode(
      {required this.name, required this.episode, required this.links});
}
