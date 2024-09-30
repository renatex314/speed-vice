import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:speed_vice/app_widget.dart';

import 'app_module.dart';

void main() {
  showSplashScreen();

  return runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

void showSplashScreen() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(
    const Duration(
      seconds: 2,
    ),
  ).then(
    (value) {
      FlutterNativeSplash.remove();
    },
  );
}
