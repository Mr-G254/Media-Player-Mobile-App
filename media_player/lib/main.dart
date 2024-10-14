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
      androidShowNotificationBadge: true,
      notificationColor: Color(0xff5C1C14),
      androidNotificationIcon: 'mipmap/launcher_icon'
    ),
  );

  runApp(MaterialApp(
    home: const Splashscreen(),
    navigatorObservers: [App.routeObserver],
  ));
}

