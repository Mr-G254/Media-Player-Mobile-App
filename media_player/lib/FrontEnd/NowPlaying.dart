import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class NowPlaying extends StatefulWidget{
  final SongModel song;
  const NowPlaying({super.key,required this.song});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying>{

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
            backgroundColor: Color(0xff510723),
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
                widget.song.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.song.artist == "<unknown>" ? "unknown" : widget.song.artist!,
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
                child: const Image(
                  image: AssetImage("icons/shuffle.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              ),
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/heart.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              ),
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/loop.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(right: 25,left: 25,top: 15,bottom: 15),
          width: double.infinity,
          child: ProgressBar(
            progress: Duration(seconds: 0),
            total: Duration(milliseconds: widget.song.duration!),
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
          padding: const EdgeInsets.only(top: 20,right: 40,left: 40),
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
              ),
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/play.png"),
                  height: 50,
                  width: 50,
                ),
              ),
              GestureDetector(
                child: const Image(
                  image: AssetImage("icons/next.png"),
                  color: Colors.white,
                  height: 30,
                  width: 30,
                ),
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
        child: window,
      ),
    );
  }
}