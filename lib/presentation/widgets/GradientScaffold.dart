import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    this.appBar,
    this.body,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final body = this.body;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.blueGrey],
          stops: [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        body: body,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
      ),
    );
  }
}
