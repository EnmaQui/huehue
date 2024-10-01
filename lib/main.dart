import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huehue/app.routes.dart';
import 'package:huehue/presentation/screen/shell/shell_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file dependeing on the envoirenment
  // The .env.dev file is only used for development
  if (!kReleaseMode) {
    await dotenv.load(fileName: ".env.dev");
  }

  setSystemChrome();

  runApp(const MyApp());
}
void setSystemChrome() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa Interactivo de Nicaragua',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: appRoutes,
      initialRoute: ShellScreen.routeName,
    );
  }
}

