import 'dart:convert';

class VideoResponse {
  VideoResponse({
    required this.id,
    required this.results,
  });

  int id;
  List<Video> results;

  factory VideoResponse.fromJson(String str) =>
      VideoResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VideoResponse.fromMap(Map<String, dynamic> json) => VideoResponse(
        id: json["id"],
        results: List<Video>.from(json["results"].map((x) => Video.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
      };
}

class Video {
  String iso6391;
  String iso31661;
  String name;
  String key;
  String site;
  int size;
  String type;
  bool official;
  DateTime publishedAt;
  String id;

  Video({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory Video.fromJson(String str) => Video.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Video.fromMap(Map<String, dynamic> json) => Video(
        iso6391: json["iso_639_1"],
        iso31661: json["iso_3166_1"],
        name: json["name"],
        key: json["key"],
        site: json["site"],
        size: json["size"],
        type: json["type"],
        official: json["official"],
        publishedAt: DateTime.parse(json["published_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "iso_639_1": iso6391,
        "iso_3166_1": iso31661,
        "name": name,
        "key": key,
        "site": site,
        "size": size,
        "type": type,
        "official": official,
        "published_at": publishedAt.toIso8601String(),
        "id": id,
      };
}
