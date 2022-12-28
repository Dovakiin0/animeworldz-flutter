// ignore_for_file: file_names

class SearchAnime {
  final String id;
  final String title;
  final String image;
  final String releaseDate;
  final String subOrDub;

  SearchAnime(
      {required this.id,
      required this.title,
      required this.image,
      required this.releaseDate,
      required this.subOrDub});

  factory SearchAnime.fromJson(Map<String, dynamic> json) {
    return SearchAnime(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        releaseDate: json['releaseDate'],
        subOrDub: json['subOrDub']);
  }
}

class RecentAnime {
  final String id;
  final String episodeId;
  final int episodeNumber;
  final String title;
  final String image;
  final String url;

  RecentAnime(
      {required this.id,
      required this.episodeId,
      required this.episodeNumber,
      required this.title,
      required this.image,
      required this.url});

  factory RecentAnime.fromJson(Map<String, dynamic> json) {
    return RecentAnime(
        id: json['id'],
        episodeId: json['episodeId'],
        episodeNumber: json['episodeNumber'],
        title: json['title'],
        image: json['image'],
        url: json['url']);
  }
}

class TopAiringAnime {
  final String id;
  final String title;
  final String image;
  final String url;
  final List<dynamic> genres;

  TopAiringAnime(
      {required this.id,
      required this.title,
      required this.image,
      required this.url,
      required this.genres});

  factory TopAiringAnime.fromJson(Map<String, dynamic> json) {
    return TopAiringAnime(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        url: json['url'],
        genres: json['genres']);
  }
}

class AnimeInfo {
  final String id;
  final String title;
  final String image;
  final String url;
  final String releaseDate;
  final String description;
  final List<dynamic> genres;
  final String subOrDub;
  final String type;
  final String status;
  final int totalEpisodes;
  final String otherName;
  final List<dynamic> episodes;

  AnimeInfo(
      {required this.id,
      required this.title,
      required this.image,
      required this.url,
      required this.releaseDate,
      required this.status,
      required this.type,
      required this.totalEpisodes,
      required this.otherName,
      required this.subOrDub,
      required this.description,
      required this.genres,
      required this.episodes});

  factory AnimeInfo.fromJson(Map<String, dynamic> json) {
    return AnimeInfo(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        url: json['url'],
        releaseDate: json['releaseDate'],
        status: json['status'],
        type: json['type'],
        totalEpisodes: json['totalEpisodes'],
        otherName: json['otherName'],
        subOrDub: json['subOrDub'],
        description: json['description'],
        genres: json['genres'],
        episodes: json['episodes']);
  }
}

class Episode {
  final String id;
  final int number;
  final String url;

  Episode({required this.id, required this.number, required this.url});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(id: json['id'], number: json['number'], url: json['url']);
  }
}

class EpisodeSources {
  final String url;
  final String quality;
  final bool isM3U8;

  EpisodeSources(
      {required this.url, required this.quality, required this.isM3U8});

  factory EpisodeSources.fromJson(Map<String, dynamic> json) {
    return EpisodeSources(
        url: json['url'], quality: json['quality'], isM3U8: json['isM3U8']);
  }
}

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
