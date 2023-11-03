import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  late List<String> imageUrls;
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
    // Set timer to change images every 10 seconds
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      changeImage();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void fetchDataFromApi() async {
    final response =
        await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'] is List) {
        List<String> urls = [];
        for (var anime in data['data']) {
          if (anime['images']['jpg'] != null &&
              anime['images']['jpg']['image_url'] != null) {
            urls.add(anime['images']['jpg']['image_url']);
          }
        }
        setState(() {
          imageUrls = urls;
        });
      }
    }
  }

  void changeImage() {
    if (imageUrls != null && imageUrls.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex + 1) % imageUrls.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 111, 244),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Anggota Kelompok 17',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 80,
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Warna border putih
                        width: 2.0, // Lebar border
                      ),
                      shape: BoxShape.circle, // Membuat gambar menjadi bulat
                    ),
                    child: ClipOval(
                      clipBehavior:
                          Clip.hardEdge, // Untuk membuat gambar memiliki border
                      child: Image.network(
                        imageUrls != null && imageUrls.isNotEmpty
                            ? imageUrls[currentIndex]
                            : "https://example.com/placeholder_image.jpg",
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text('Na'),
                          subtitle: Text('21120121130041'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Rich'),
                          subtitle: Text('21120121130039'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Roy'),
                          subtitle: Text('21120121140104'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text('Ab'),
                          subtitle: Text('21120121140153'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
