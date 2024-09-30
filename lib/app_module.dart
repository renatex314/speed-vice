import 'package:flutter_modular/flutter_modular.dart';
import 'package:speed_vice/routes/home/home.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    r.module(Modular.initialRoute, module: HomeModule());
  }
}
