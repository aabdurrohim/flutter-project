import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'home.dart';

class MoreDetailPage extends StatefulWidget {
  final int item;
  final String title;
  const MoreDetailPage({Key? key, required this.item, required this.title})
      : super(key: key);

  @override
  _MoreDetailPageState createState() => _MoreDetailPageState();
}

class _MoreDetailPageState extends State<MoreDetailPage> {
  late Future<Chapter> chapter;

  @override
  void initState() {
    super.initState();
    chapter = fetchEpisodes(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 54, 79, 244),
          title: Text(
            widget.title,
            overflow: TextOverflow.ellipsis,
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<Chapter>(
              future: chapter,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                      child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child:
                            Image.network(snapshot.data!.images.jpg.image_url),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        snapshot.data!.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      'Score: ' + snapshot.data!.score.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      'Chapter: ' + snapshot.data!.chapters.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      'Volume: ' + snapshot.data!.volumes.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 20),
                      child: Text(
                        snapshot.data!.synopsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            overflow: TextOverflow.visible),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ]));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}

class Chapter {
  final String title;
  final int malId;
  Images images;
  final double score;
  final int chapters;
  final String synopsis;
  final int volumes;

  Chapter(
      {required this.title,
      required this.malId,
      required this.images,
      required this.score,
      required this.chapters,
      required this.volumes,
      required this.synopsis});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
        title: json['title'],
        malId: json['mal_id'],
        images: Images.fromJson(json['images']),
        score: json['score'],
        chapters: json['chapters'],
        synopsis: json['synopsis'],
        volumes: json['volumes']);
  }
}

class Images {
  final Jpg jpg;

  Images({required this.jpg});
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Jpg.fromJson(json['jpg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'jpg': jpg.toJson(),
      };
}

class Jpg {
  String image_url;
  String small_image_url;
  String large_image_url;

  Jpg({
    required this.image_url,
    required this.small_image_url,
    required this.large_image_url,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) {
    return Jpg(
      image_url: json['image_url'],
      small_image_url: json['small_image_url'],
      large_image_url: json['large_image_url'],
    );
  }
  //to json
  Map<String, dynamic> toJson() => {
        'image_url': image_url,
        'small_image_url': small_image_url,
        'large_image_url': large_image_url,
      };
}

Future<Chapter> fetchEpisodes(id) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/manga/$id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Chapter.fromJson(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
