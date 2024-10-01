import 'package:flutter/material.dart';
import 'package:huehue/presentation/screen/explorar_screen.dart';
import 'package:huehue/presentation/screen/home_screen.dart';
import 'package:huehue/presentation/screen/map_screen.dart';

class ShellScreen extends StatefulWidget {
  static const String routeName = '/shell';
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            MapScreen(),
            ExplorarScreen(),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Explorar',
            ),
          ],
          onTap: (val) => _pageController.jumpToPage(val),
        ),
    );
  }
}
