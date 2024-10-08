import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  ValueNotifier<List<Widget>> songWidget = ValueNotifier([]);
  List<SongModel> selectedSongs = [];
  bool loading = false;

  void removeSong(SongModel song)async{
    await App.removeSongFromPlaylist(widget.playlist.name, song);
    widget.playlist.songs.remove(song.data);
    songs.remove(song);

    if(context.mounted){
      Navigator.pop(context);
    }
    refresh();

  }

  void refresh(){
    List<Widget> widgets = [];

    for(final i in songs){
      widgets.add(SongTile(song: i, list: 'playlist',removeSong: removeSong,));
    }

    songWidget.value = widgets;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    App.currentPlaylist = widget.playlist;
    App.currentPlaylistSongs.clear();
    if(widget.playlist.songs.isNotEmpty){
      List<Widget> widgets = [];
      for(final i in App.allSongs){

        if(widget.playlist.songs.contains(i.data)){
          songs.add(i);
          App.currentPlaylistSongs.add(i);
          widgets.add(SongTile(song: i, list: 'playlist',removeSong: removeSong,));
        }
      }

      songWidget.value = widgets;

      // setState(() {
      //
      // });
    }
  }

  void addSongs()async{
    setState(() {
      loading = true;
    });

    List<Widget> widgets = songWidget.value;
    for(final i in selectedSongs){
      widget.playlist.songs.add(i.data);
      widgets.add(SongTile(song: i, list: 'playlist'));
    }

    await App.addSongsToPlaylist(widget.playlist.name, selectedSongs).then((val){
      Navigator.pop(context,widget.playlist);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistSongs(playlist: widget.playlist)));

      // setState(() {
      //   loading = false;
      // });
      songWidget.value = widgets;
    });
  }

  void deletePlaylist()async{
    await App.deletePlaylist(widget.playlist).then((onValue){
      Navigator.pop(context);
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
          padding: const EdgeInsets.all(5),
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
                  onTap: ()async{
                    var ans = await Navigator.push(context, DialogRoute(context: context, builder: (context) => AskDelete(itemToDelete: "'${widget.playlist.name.split('_')[0]}' playlist",isSong: false,)));

                    if(ans){
                      deletePlaylist();
                    }
                  },
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

                    if(selected != null){
                      selectedSongs.addAll(selected);
                      addSongs();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // padding: EdgeInsets.all(10),
          child: ValueListenableBuilder(
              valueListenable: songWidget,
              builder: (context,value,child){
                return ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: value
                );
              }
          )
        ),
      ],
    );

    final fullWindow = Scaffold(
      backgroundColor: const Color(0xff781F15),
      appBar: AppBar(
        backgroundColor: const Color(0xff781F15),
        leading: IconButton(
          onPressed: loading ? null : (){
            Navigator.pop(context,widget.playlist);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 28,)
        ),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: window,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Visibility(
              visible: loading,
              child: const CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                strokeWidth: 5,
                color: Color(0xffE1246B),
                backgroundColor: Colors.transparent,
              ),
            )
          )
        ],
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (val){
        if(val == false){
          Navigator.of(context).pop(widget.playlist);
        }
      },
      child: fullWindow,
    );
  }
}