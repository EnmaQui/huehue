import 'package:flutter/material.dart';
import 'package:huehue/presentation/screen/explorer/explorar_screen.dart';
import 'package:huehue/presentation/screen/home/home_screen.dart';
import 'package:huehue/presentation/screen/map/map_screen.dart';
import 'package:huehue/presentation/screen/pruebas/prueba_screen.dart';
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
            PruebasScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blue, // Cambia el color del ícono a azul
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.blue, // Cambia el color del ícono a azul
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore, // Cambié a un ícono diferente para 'Explorar'
              color: Colors.blue, // Cambia el color del ícono a azul
            ),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.note, // Cambié a un ícono diferente para 'Pruebas'
              color: Colors.blue, // Cambia el color del ícono a azul
            ),
            label: 'Pruebas',
          ),
        ],
        onTap: (val) => _pageController.jumpToPage(val),
      ),

    );
  }
}
