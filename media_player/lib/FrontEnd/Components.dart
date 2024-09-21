import 'package:flutter/material.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/NowPlaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../BackEnd/App.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final String list;
  const SongTile({super.key, required this.song, required this.list});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder<SongModel>(
      valueListenable: App.currentSong,
      builder: (context,value,child){
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
                  child: Image(
                    color: song == value ? const Color(0xffE1246B) : Colors.white,
                    image: const AssetImage("icons/wave.png"),
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
                          style: TextStyle(
                            fontFamily: "Orelega",
                            fontSize: 18,
                            color: song == value ? const Color(0xffE1246B) : Colors.white,
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
                GestureDetector(
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Image(
                        color: song == value ? const Color(0xffE1246B) : Colors.white,
                        image: const AssetImage("icons/menu.png"),
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
            App.currentList = list;

            if(list == "recent"){
              App.currentSongList = App.recentSongs;
            }else if(list == 'favourite'){
              App.currentSongList = App.favouriteSongs;
            }else if(list == 'all'){
              App.currentSongList = App.allSongs;
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
    );
  }
}

class PlaylistTile extends StatelessWidget{
  final Playlist playlist;
  const PlaylistTile({super.key,required this.playlist});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xff510723),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(30),
                child: const Image(
                  image: AssetImage("icons/playlist.png"),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 5,right: 7),
                child: Text(
                  '${playlist.songs.length} songs',
                  style: const TextStyle(
                    fontFamily: "Orelega",
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.only(bottom: 5,left: 8),
                child: Text(
                  playlist.name.split('_')[0],
                  style: const TextStyle(
                    fontFamily: "Orelega",
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class NewPlaylistDialog extends StatefulWidget {
  const NewPlaylistDialog({super.key});

  @override
  State<NewPlaylistDialog> createState() => _NewPlaylistDialogState();

}

class _NewPlaylistDialogState extends State<NewPlaylistDialog>{
  late TextEditingController controller;
  String label = "Name";
  bool isBlank = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TextEditingController();
    controller.addListener((){
      setState(() {
        isBlank = controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15),
      child: Dialog(
        backgroundColor: const Color(0xff781F15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Add a new playlist',
                style: TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15,left: 15),
              child: TextField(
                controller: controller,
                cursorColor: Colors.white,
                style: const TextStyle(
                    height: 0.8,
                    fontFamily: "Orelega",
                    fontSize: 20,
                    color: Colors.white
                ),
                onTap: (){
                  setState(() {
                    label = "";
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff5C1C14),
                  focusColor: const Color(0xff5C1C14),
                  labelText: label,
                  labelStyle: const TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 18,
                      color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white,width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white,width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff510723),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        onPressed: isBlank? null : (){
                          Navigator.pop(context,controller.text);
                        },
                        child: const Text(
                          'create',
                          style: TextStyle(
                            fontFamily: "Orelega",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff510723),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'cancel',
                          style: TextStyle(
                            fontFamily: "Orelega",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}