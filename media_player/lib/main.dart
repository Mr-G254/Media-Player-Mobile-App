import 'package:flutter/material.dart';
import 'BackEnd/App.dart';
import 'FrontEnd/Splashscreen.dart';

void main() {
  runApp(MaterialApp(
    home: const Splashscreen(),
    navigatorObservers: [App.routeObserver],
  ));
}

