import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speed_vice/views/speedometer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  double _factor = 0;

  void updateFactor() {
    setState(() {
      _factor = Random().nextDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: updateFactor,
              child: Speedometer(
                factor: _factor,
                animated: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
