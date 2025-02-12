import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'BackEnd/App.dart';
import 'BackEnd/AudioHandler.dart';
import 'FrontEnd/Splashscreen.dart';

Future<void> main() async {
   App.audioHandler = await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationOngoing: true,
      androidNotificationChannelName: 'Music playback',
      notificationColor: Color(0xff5C1C14),
      androidNotificationIcon: 'mipmap/launcher_icon'
    ),
  );

  runApp(MaterialApp(
    home: const Splashscreen(),
    navigatorObservers: [App.routeObserver],
    theme: ThemeData(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white)
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xff781F15),
      )
    ),
  ));
}

