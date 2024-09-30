import 'package:flutter_modular/flutter_modular.dart';
import 'package:speed_vice/routes/home/controller.dart';
import 'package:speed_vice/routes/home/view.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(HomeController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const HomeView());
  }
}
