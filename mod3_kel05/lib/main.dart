import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'screens/detail.dart';
import 'screens/home.dart';
import 'screens/about.dart';
import 'screens/splashscreen.dart';

void main() async {
  runApp(const AnimeApp());
}

class AnimeApp extends StatelessWidget {
  const AnimeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Anime List',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: SplashScreenPage(),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final items = const [
    Icon(
      Icons.home,
      size: 20,
    ),
    Icon(
      Icons.people,
      size: 20,
    )
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 105, 215),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 50,
        backgroundColor: Color.fromARGB(0, 32, 32, 202),
        animationDuration: const Duration(milliseconds: 500),
        buttonBackgroundColor:
            Colors.white, // Warna latar belakang tombol aktif
        color: Colors.white, // Warna ikon dan teks di bottom navigation bar
        animationCurve: Curves.easeInOut, // Efek animasi
      ),
      body: Container(
        color: Color.fromARGB(255, 102, 137, 182),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HomePage();
        break;
      case 1:
        widget = const About();
        break;
      default:
        widget = const HomePage();
        break;
    }
    return widget;
  }
}
