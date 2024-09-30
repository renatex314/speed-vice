import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:speed_vice/utils.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "SpeedVice",
      theme: ThemeData(
        primarySwatch: Utils.getMaterialColor(const Color(0xff0055ff)),
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
