import 'package:flutter/material.dart';
import 'package:media_player/FrontEnd/NowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../BackEnd/App.dart';

class SongTile extends StatelessWidget{
  final SongModel song;
  const SongTile({super.key,required this.song});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xff510723),
                  borderRadius: BorderRadius.circular(6)
              ),
              child: const Image(
                image: AssetImage("icons/wave.png"),
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      song.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: "Orelega",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      '${Duration(milliseconds: song.duration!).inMinutes.toString().padLeft(2, '0')}:${Duration(milliseconds: song.duration!).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontFamily: "Orelega",
                        fontSize: 15,
                        color: Colors.white54,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // const Expanded(child: SizedBox()),
            GestureDetector(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Image(
                    image: AssetImage("icons/menu.png"),
                    width: 30,
                    height: 30,
                  )
              ),
            )
          ],
        ),
      ),
      onTap: (){
        if(!(App.currentSong == song)){
          App.playSong(song);
        }

        // Navigator.push(context, MaterialPageRoute(builder: (context) => NowPlaying(song: song)));
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context,animation,secondaryAnimation) =>NowPlaying(song: song),
          transitionsBuilder: (context,animation,secondaryAnimation,child){
            return SlideTransition(
              position: animation.drive(Tween(begin: const Offset(0, 1),end: const Offset(0, 0)).chain(CurveTween(curve: Curves.easeOut))),
              child: child,
            );
          }
        ));
      },
    );
  }
}