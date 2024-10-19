import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huehue/app.routes.dart';
import 'package:huehue/presentation/blocs/calculator/calculator_bloc.dart';
import 'package:huehue/presentation/blocs/place/place_bloc.dart';
import 'package:huehue/presentation/screen/shell/shell_screen.dart';
import 'package:huehue/utils/service.locator.utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file dependeing on the envoirenment
  // The .env.dev file is only used for development
  if (!kReleaseMode) {
    await dotenv.load(fileName: ".env.dev");
  }

  setSystemChrome();

  setUpServiceLocator();

  runApp(const MyApp());
}

void setSystemChrome() {
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<PlaceBloc>(),
        ),
        BlocProvider(
          create: (context) => CalculatorBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Mapa Interactivo de Nicaragua',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark)),
          applyElevationOverlayColor: false,
          primarySwatch: Colors.blue,
          fontFamily: 'FranklinGothic',
        ),
        routes: appRoutes,
        initialRoute: ShellScreen.routeName,
      ),
    );
  }
}
