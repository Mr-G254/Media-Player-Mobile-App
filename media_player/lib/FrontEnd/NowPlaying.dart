import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../BackEnd/App.dart';

class NowPlaying extends StatefulWidget{
  final SongModel song;
  const NowPlaying({super.key,required this.song});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>{
  Duration currentPosition = Duration(seconds: 0);
  late StreamSubscription<Duration> progressEvent;
  late bool isFavourite;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    App.currentSong.value = widget.song;
    isFavourite = App.favouriteSongs.contains(widget.song);
    progressEvent = App.player.onPositionChanged.listen((dur) {
      setState(() {
        currentPosition = dur;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    progressEvent.cancel();
  }

  @override
  Widget build(BuildContext context){
    final AppBar bar = AppBar(
      backgroundColor: const Color(0xff781F15),
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios,size: 28,color: Colors.white,)
      ),
      title: const Text(
        'Now playing',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: "Orelega",
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );

    final window = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: CircleAvatar(
            radius: double.infinity,
            backgroundColor: const Color(0xff510723),
            child: Container(
              padding: const EdgeInsets.all(50),
              child: const Image(
                image: AssetImage("icons/wave.png"),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 25,left: 25,bottom: 10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                App.currentSong.value.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                App.currentSong.value.artist == "<unknown>" ? "unknown" : App.currentSong.value.artist!,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 18,
                  color: Colors.white54,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 25,left: 25,top: 15,bottom: 15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: Image(
                  image: AssetImage(App.shuffle ? "icons/shuffle.png" : "icons/shuffle off.png"),
                  color: Colors.white,
                  height: 28,
                  width: 28,
                ),
                onTap: (){
                  setState(() {
                    App.shuffle = !App.shuffle;
                  });

                  if(!(App.shuffledSongList.contains(App.currentSong.value))){
                    App.shuffledSongList.add(App.currentSong.value);
                  }
                },
              ),
              GestureDetector(
                child: Image(
                  image: AssetImage(isFavourite ? "icons/heart2.png" : "icons/heart.png"),
                  color: Colors.white,
                  height: 28,
                  width: 28,
                ),
                onTap: (){
                  if(isFavourite){
                    App.deleteFavourite(App.currentSong.value);

                    setState(() {
                      isFavourite = false;
                    });
                  }else{
                    App.addFavourite(App.currentSong.value);

                    setState(() {
                      isFavourite = true;
                    });
                  }
                },
              ),
              GestureDetector(
                child: Image(
                  image: AssetImage(App.loop== 0 ? "icons/loop off.png" : App.loop== 1 ? "icons/loop.png" : "icons/loop once.png"),
                  color: Colors.white,
                  height: 28,
                  width: 28,
                ),
                onTap: (){
                  if(App.loop == 0){
                    setState(() {
                      App.loop = 1;
                    });
                  }else if(App.loop == 1){
                    setState(() {
                      App.loop = 2;
                    });
                  }else if(App.loop == 2){
                    setState(() {
                      App.loop = 0;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Container(
            width: double.infinity,
          padding: const EdgeInsets.only(right: 25,left: 25,top: 15,bottom: 15),
          child: ProgressBar(
            progress: currentPosition,
            total: Duration(milliseconds: App.currentSong.value.duration!),
            onSeek: (position) => App.seekSong(position),
            baseBarColor: Colors.white,
            progressBarColor: const Color(0xff510723),
            thumbColor: const Color(0xff510723),
            thumbRadius: 8,
            barHeight: 3,
            timeLabelTextStyle: const TextStyle(
              fontFamily: "Orelega",
              fontSize: 16,
              color: Colors.white54,
            ),
          )
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width/2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/previous.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
                onTap: (){
                  setState(() {
                    App.previousSong();
                    isFavourite = App.favouriteSongs.contains(App.currentSong.value);
                  });
                },
              ),
              GestureDetector(
                child: Image(
                  image: AssetImage(App.musicIsPlaying.value ? "icons/pause.png" : "icons/play.png"),
                  height: 50,
                  width: 50,
                ),
                onTap: (){
                  App.playOrpause();
                },
              ),
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/next.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
                onTap: (){
                  setState(() {
                    App.nextSong();
                    isFavourite = App.favouriteSongs.contains(App.currentSong.value);
                  });
                },
              ),
            ],
          ),
        )
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xff781F15),
      appBar: bar,
      body: Container(
        padding: const EdgeInsets.all(0),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: window,
        ),
      ),
    );
  }
}