import 'package:flutter/material.dart';
import 'package:huehue/presentation/screen/explorer/explorar_screen.dart';
import 'package:huehue/presentation/screen/home/home_screen.dart';
import 'package:huehue/presentation/screen/map/map_screen.dart';
import 'package:huehue/presentation/screen/pruebas/prueba_screen.dart';
import 'package:iconsax/iconsax.dart';

class ShellScreen extends StatefulWidget {
  static const String routeName = '/shell';
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  final _pageController = PageController();
  final navBarColor = const Color(0xFF535C91);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          PruebasScreen(),
          HomeScreen(),
          MapScreen(),
          ExplorarScreen(),
        ],
      ),
      extendBody: true,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Center(
      //     child: Icon(
      //       Iconsax.calculator,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 70),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: navBarColor,
            boxShadow: [
              BoxShadow(
                color: navBarColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final width = constraints.maxWidth / 2;
              return Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.jumpToPage(0);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: width,
                      height: 36,
                      child: const Icon(Iconsax.home, color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // _pageController.jumpToPage(1);
                    },
                    child: Container(
                      width: width,
                      color: const Color.fromARGB(0, 236, 94, 94),
                      height: 36,
                      child:
                          const Icon(Iconsax.calculator, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
