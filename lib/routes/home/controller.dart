import 'package:mobx/mobx.dart';

part 'controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store {
  @observable
  int _counter = 0;

  @action
  void increment() => _counter++;

  int get counter => _counter;
}
