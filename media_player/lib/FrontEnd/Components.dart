import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/NowPlaying.dart';
import 'package:media_player/FrontEnd/PlaylistSongs.dart';
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

class PlaylistTile extends StatefulWidget {
  final Playlist playlist;

  const PlaylistTile({super.key, required this.playlist});

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile>{

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
                  '${widget.playlist.songs.length} songs',
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
                  widget.playlist.name.split('_')[0],
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
        await Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistSongs(playlist: widget.playlist))).then((val){
          setState(() {

          });
        });
      },
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
  const AskDelete({super.key,required this.itemToDelete});

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
                "Are you sure you want to delete $itemToDelete",
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