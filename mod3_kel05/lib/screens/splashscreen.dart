import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/main.dart';
import '/screens/home.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late Future<List<String>> animeData;

  @override
  void initState() {
    super.initState();
    animeData = fetchRandomAnimeData();
    openSplashScreen();
  }

  openSplashScreen() async {
    await Future.delayed(Duration(seconds: 5)); // Ubah durasi sesuai kebutuhan
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return NavBar(); // Ganti dengan halaman utama Anda
    }));
  }

  Future<List<String>> fetchRandomAnimeData() async {
    final response =
        await http.get(Uri.parse('https://api.jikan.moe/v4/random/characters'));

    if (response.statusCode == 200) {
      var jsonResponse =
          json.decode(response.body)['data'] as Map<String, dynamic>;
      if (jsonResponse.isNotEmpty) {
        final image = jsonResponse['images']['jpg']['image_url'];
        final name = jsonResponse['name'];
        return [image, name];
      }
    }
    return ["", ""]; // Kembalikan string kosong jika ada kesalahan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: FutureBuilder<List<String>>(
          future: animeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:
                            NetworkImage(snapshot.data![0]), // Gambar dari API
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    snapshot.data![1], // Nama karakter dari API
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
