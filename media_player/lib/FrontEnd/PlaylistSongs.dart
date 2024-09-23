import 'package:flutter/material.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../BackEnd/App.dart';

class PlaylistSongs extends StatefulWidget{
  final Playlist playlist;
  const PlaylistSongs({super.key,required this.playlist});

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();

}

class _PlaylistSongsState extends State<PlaylistSongs>{
  List<SongModel> songs = [];
  List<Widget> songWidget = [];
  List<SongModel> selectedSongs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.playlist.songs.isNotEmpty){
      for(final i in App.allSongs){
        if(widget.playlist.songs.contains(i.data)){
          songs.add(i);
          songWidget.add(SongTile(song: i, list: 'playlist'));
        }
      }

      setState(() {

      });
    }
  }

  void addSongs()async{
    await App.addSongsToPlaylist(widget.playlist.name, songs).then((val){
      for(final i in selectedSongs){
        widget.playlist.songs.add(i.data);
        songWidget.add(SongTile(song: i, list: 'playlist'));
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PlaylistSongs(playlist: widget.playlist)));

    });
  }

  @override
  Widget build(BuildContext context){
    final window = Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 10,right: 70,left: 70),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color(0xff510723),
            child: Container(
              padding: const EdgeInsets.all(40),
              child: const Image(
                  image: AssetImage("icons/playlist.png")
              ),
            )
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          child: Text(
            widget.playlist.name.split('_')[0],
            style: const TextStyle(
              fontFamily: "Orelega",
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: const Image(
                    image: AssetImage("icons/bin.png"),
                    height: 23,
                    width: 23,
                  ),
                  onTap: (){},
                ),
              ),
              const SizedBox(width: 20,),
              Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: const Image(
                    image: AssetImage("icons/play.png"),
                    height: 48,
                    width: 48,
                  ),
                  onTap: (){},
                ),
              ),
              SizedBox(width: 20,),
              Container(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  child: const Image(
                    image: AssetImage("icons/plus.png"),
                    height: 23,
                    width: 23,
                  ),
                  onTap: ()async{
                    selectedSongs.clear();
                    var selected = await Navigator.push(context, DialogRoute(context: context, builder: (context) => SelectSongs(currentSongs: songs)));
                    selectedSongs.addAll(selected);
                    addSongs();

                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // padding: EdgeInsets.all(10),
          child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: songWidget
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: const Color(0xff781F15),
      appBar: AppBar(
        backgroundColor: const Color(0xff781F15),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 28,)
        ),
      ),
      body: window,
    );
  }
}