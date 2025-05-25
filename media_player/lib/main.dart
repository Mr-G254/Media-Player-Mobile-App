import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'BackEnd/App.dart';
import 'BackEnd/AudioHandler.dart';
import 'FrontEnd/Splashscreen.dart';

Future<void> main() async {
  final mySystemTheme= SystemUiOverlayStyle.light
      .copyWith(
      systemNavigationBarColor: Colors.transparent,
  );

  SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

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
    debugShowCheckedModeBanner: false,
    home: const Splashscreen(),
    navigatorObservers: [App.routeObserver],
    theme: ThemeData(
      primaryColor: const Color(0xffE1246B),
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          color: Colors.white,
          fontFamily: "Orelega",
          fontSize: 18,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xff781F15),
      )
    ),
  ));
}

