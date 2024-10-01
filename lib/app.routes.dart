import 'package:flutter/material.dart';
import 'package:huehue/presentation/screen/no_permissions/LocationDeniedPermission.dart';
import 'package:huehue/presentation/screen/shell/shell_screen.dart';

final appRoutes = <String, WidgetBuilder>{
  ShellScreen.routeName: (context) => const ShellScreen(),
  LocationDeniedPermission.routeName: (context) => const LocationDeniedPermission(),
};