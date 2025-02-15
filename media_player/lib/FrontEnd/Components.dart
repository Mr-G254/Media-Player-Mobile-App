import 'dart:io';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:media_player/BackEnd/Database.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/NowPlaying.dart';
import 'package:media_player/FrontEnd/PlaylistSongs.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:units_converter/units_converter.dart';
import 'package:video_storage_query/video_storage_query.dart';
import '../BackEnd/App.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final String list;
  final String? playlistName;
  final Function(SongModel)? removeSong;
  final String searchText;
  const SongTile({super.key, required this.song, required this.list,required this.searchText,this.removeSong,this.playlistName});

  @override
  Widget build(BuildContext context){
    Map<String, HighlightedWord> words = {
      searchText : HighlightedWord(
        textStyle: const TextStyle(
          fontFamily: "Orelega",
          fontSize: 18,
          color: Color(0xffE1246B),
          overflow: TextOverflow.ellipsis
        ),
      )
    };

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
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: const Color(0xff510723),
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Image(
                    color: list == 'none'? Colors.white : song == value ? const Color(0xffE1246B) : Colors.white,
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
                        padding: const EdgeInsets.only(right: 10),
                        child: TextHighlight(
                          text: song.title,
                          words: words,
                          overflow: TextOverflow.ellipsis,
                          textStyle: TextStyle(
                            fontFamily: "Orelega",
                            fontSize: 18,
                            color: list == 'none'? Colors.white : song == value ? const Color(0xffE1246B) : Colors.white,
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
                Visibility(
                  visible: list != 'none',
                  child: GestureDetector(
                    child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image(
                          color: song == value ? const Color(0xffE1246B) : Colors.white,
                          image: const AssetImage("icons/menu.png"),
                          width: 30,
                          height: 30,
                        )
                    ),
                    onTap: (){
                      Navigator.push(context,DialogRoute(context: context, builder: (context) => SongOptions(song: song, list: list,removeSong: removeSong,)));
                    },
                  ),
                )
              ],
            ),
          ),
          onTap: ()async{
            if(!(App.currentSong == song)){
              App.playSong(song);
            }
            App.currentList = list;

            if(playlistName != null){
              var songList = await AppDatabase.getPlaylistSongs(playlistName!);
              App.currentPlaylistSongs.clear();

              for(final i in App.allSongs){
                if(songList.contains(i.data)){
                  App.currentPlaylistSongs.add(i);
                }
              }
            }

            if(list == "recent"){
              App.currentPlaylistName.value = '';
              App.currentSongList = App.recentSongs;
            }else if(list == 'favourite'){
              App.currentPlaylistName.value = '';
              App.currentSongList = App.favouriteSongs;
            }else if(list == 'all'){
              App.currentPlaylistName.value = '';
              App.currentSongList = App.allSongs;
            }else if(list == 'playlist'){
              App.currentPlaylistName.value = playlistName!;
              App.currentSongList = App.currentPlaylistSongs;
            }else if(list == 'none'){
              App.currentPlaylistName.value = '';
              App.currentSongList = App.allSongs;
            }

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

class PlaylistTile extends StatefulWidget {
  final Playlist playlist;

  const PlaylistTile({super.key, required this.playlist});

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile>{
  late Playlist currentPlaylist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentPlaylist = widget.playlist;
  }

  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(
        animation: Listenable.merge([App.currentPlaylistName,App.musicIsPlaying]),
        builder: (context,_){
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
                      child:
                      App.currentPlaylistName.value == widget.playlist.name?
                      MiniMusicVisualizer(
                        radius: 6,
                        color: const Color(0xffE1246B),
                        width: MediaQuery.of(context).size.width/20,
                        height: MediaQuery.of(context).size.height/10,
                        animate: App.musicIsPlaying.value,
                      ) :
                      const Image(
                        image: AssetImage("icons/playlist.png"),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(top: 5,right: 7),
                      child: Text(
                        '${currentPlaylist.songs.length} songs',
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
                        currentPlaylist.name.split('_')[0],
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
            ),
            onTap: ()async{
              var play = await Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistSongs(playlist: currentPlaylist)));

              if(play != null){
                setState(() {
                  currentPlaylist = play;
                });
                App.refreshPlaylistDisplay();
              }
            },
          );
        }
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
                    padding: const EdgeInsets.all(10),
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
                    padding: const EdgeInsets.all(10),
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

class AskDelete extends StatelessWidget {
  final String itemToDelete;
  final bool isSong;
  const AskDelete({super.key,required this.itemToDelete,required this.isSong});

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
              child: Text(
                itemToDelete,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Color(0xffE1246B),
                  overflow: TextOverflow.ellipsis
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15,left: 15),
              child: Text(
                "Are you sure you want to delete this ${isSong ? 'song': 'playlist'}?",
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff510723),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        onPressed: (){
                          Navigator.pop(context,true);
                        },
                        child: const Text(
                          'yes',
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
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff510723),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        onPressed: (){
                          Navigator.pop(context,false);
                        },
                        child: const Text(
                          'no',
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

class SelectableTile extends StatefulWidget{
  final SongModel song;
  final Function callback;
  const SelectableTile({super.key,required this.song,required this.callback});

  @override
  State<SelectableTile> createState() => _SelectableTileState();
}

class _SelectableTileState extends State<SelectableTile>{
  bool _isSelected = false;

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(right: 10,left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.song.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(5),
              height: 50,
              width: 50,
              child: Checkbox(
                  tristate: false,
                  // checkColor: const Color(0xff510723),
                  activeColor: Color(0xff510723),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: const BorderSide(color: Colors.white,width: 2),
                  value: _isSelected,
                  onChanged: (val){
                    setState(() {
                      _isSelected = val!;
                    });

                    widget.callback(widget.song);
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SelectSongs extends StatefulWidget{
  final List<SongModel> currentSongs;
  const SelectSongs({super.key,required this.currentSongs});

  @override
  State<SelectSongs> createState() => _SelectSongsState();
}

class _SelectSongsState extends State<SelectSongs>{
  List<SelectableTile> listedSongs = [];
  List<SongModel> selectedSongs = [];

  void addOrRemoveSong(SongModel song){
    if(selectedSongs.contains(song)){
      selectedSongs.remove(song);
    }else{
      selectedSongs.add(song);
    }

    setState(() {

    });
  }

  void getMissingsongs()async{
    for(final i in App.allSongs){
      if(!(widget.currentSongs.contains(i)) && i.isMusic == true){
        listedSongs.add(SelectableTile(song: i, callback: addOrRemoveSong,));
      }
    }

    setState(() {

    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    getMissingsongs();
  }

  @override
  Widget build(BuildContext context){

    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        color: const Color(0xff781F15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15,bottom: 5),
              child: const Text(
                'Add songs',
                style: TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: listedSongs,
                ),
              )
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff510723),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                        ),
                        onPressed: selectedSongs.isEmpty? null : (){
                          Navigator.pop(context,selectedSongs);
                        },
                        child: Text(
                          selectedSongs.isEmpty? "Add" : "Add(${selectedSongs.length})",
                          style: const TextStyle(
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
                      padding: const EdgeInsets.all(10),
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
            )
          ],
        ),
      ),
    );
  }
}

class SongOptions extends StatelessWidget{
  final SongModel song;
  final String list;
  final Function(SongModel)? removeSong;
  const SongOptions({super.key,required this.song,required this.list,this.removeSong});
  
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(0),
      child: Dialog(
        backgroundColor: const Color(0xff781F15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width*(2/3),
              child: Text(
                song.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Color(0xffE1246B),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Visibility(
              visible: list == 'all',
              child: ListTile(
                tileColor: Colors.transparent,
                title: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 5),
                  child: const Text(
                    'Add to playlist',
                    style: TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: ()async{
                  Navigator.pop(context);
                  Playlist? playlst = await Navigator.push(context, DialogRoute(context: context, builder: (context) => AddSongToPlaylist(song: song)));

                  if(playlst != null){
                    await App.addSongsToPlaylist(playlst.name, [song]);
                  }
                },
              ),
            ),
            ListTile(
              tileColor: Colors.transparent,
              title: Container(
                padding: const EdgeInsets.only(top: 15,bottom: 5),
                child: const Text(
                  'Share',
                  style: TextStyle(
                    fontFamily: "Orelega",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: ()async{
                await App.shareSong(song).then((onValue){
                  Navigator.pop(context);
                });
              },
            ),
            Visibility(
              visible: list == 'playlist',
              child: ListTile(
                tileColor: Colors.transparent,
                title: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 5),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () => removeSong!(song),
              ),
            ),
            Visibility(
              visible: list == 'all',
              child: ListTile(
                tileColor: Colors.transparent,
                title: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 5),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: ()async{
                  Navigator.pop(context);
                  var response = await Navigator.push(context, DialogRoute(context: context, builder: (context) => AskDelete(itemToDelete: song.title,isSong: true,)));

                  if(response){
                    App.deleteSong(song);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddSongToPlaylist extends StatefulWidget {
  final SongModel song;

  AddSongToPlaylist({super.key, required this.song});

  @override
  State<AddSongToPlaylist> createState() => _AddSongToPlaylistState();
}

class _AddSongToPlaylistState extends State<AddSongToPlaylist>{
  List<Playlist> playlists = App.allPlaylist;
  int currentIndex = -1;

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        backgroundColor: const Color(0xff781F15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Select a playlist',
                style: TextStyle(
                  fontFamily: "Orelega",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 50,
                itemCount: playlists.length,
                itemBuilder: (context,index){
                  return ListTile(
                    selected: currentIndex == index,
                    selectedTileColor: const Color(0xff510723),
                    tileColor: const Color(0xff781F15),
                    title: Text(
                      playlists[index].name.split('_')[0],
                      style: const TextStyle(
                        fontFamily: "Orelega",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        currentIndex = index;
                      });
                      Navigator.pop(context,playlists[index]);
                    },
                  );
                }
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff510723),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                ),
                onPressed: ()async{
                  String? name = await Navigator.push(context, DialogRoute(context: context, builder: (context) => const NewPlaylistDialog()));

                  if(name != null){
                    await App.createPlaylist(name).then((val){
                      setState(() {
                        // playlists.add(Playlist(name: '${name}_playlist'));
                      });

                    });
                  }

                },
                child: const Text(
                  'New playlist',
                  style: const TextStyle(
                    fontFamily: "Orelega",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(right: 10,left: 10,bottom: 5),
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
          ],
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final VideoItem video;
  VideoCard({super.key, required this.video});

  ValueNotifier<String> thumbnail = ValueNotifier('');

  @override
  State<VideoCard> createState() => _VideoCardState();

}

class _VideoCardState extends State<VideoCard> with AutomaticKeepAliveClientMixin{

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    super.build(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 3,left: 3),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          App.playLocalVideo(widget.video.path);
        },
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            color: const Color(0xff5C1C14),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Card(
                            color: const Color(0xff510723),
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: ValueListenableBuilder(
                              valueListenable: widget.thumbnail,
                              builder: (context,value,child){
                                if(value.isEmpty){
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Image(
                                      image: AssetImage("icons/wave.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                }else{
                                  return Image.file(
                                    File(value),
                                    fit: BoxFit.cover,
                                  );
                                }
                              }
                            )
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10),
                                child: Text(
                                  widget.video.name,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: "Orelega",
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(right: 5,left: 5),
                                        child: Text(
                                          // "Dur : ${int.parse(widget.video.duration).convertFromTo(TIME.milliseconds,TIME.minutes)!.toStringAsFixed(2)}",
                                          "Dur : ${Duration(milliseconds: int.parse(widget.video.duration)).toString().split('.')[0]}",
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: "Orelega",
                                            fontSize: 15,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(right: 5,left: 5),
                                        child: Text(
                                          "Size : ${int.parse(widget.video.size).convertFromTo(DIGITAL_DATA.byte, DIGITAL_DATA.megabyte)!.toStringAsFixed(2)} MB",
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: "Orelega",
                                            fontSize: 15,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    child: GestureDetector(
                                      child: const Image(
                                        image: AssetImage("icons/menu.png"),
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    );

  }
}