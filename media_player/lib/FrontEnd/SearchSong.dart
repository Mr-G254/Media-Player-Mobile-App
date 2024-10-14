import 'package:flutter/material.dart';
import 'package:media_player/BackEnd/App.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Components.dart';

class Searchsong extends StatefulWidget{
  const Searchsong({super.key});

  @override
  State<Searchsong> createState() => _SearchSongState();
}

class _SearchSongState extends State<Searchsong>{
  final searchText = TextEditingController();
  List<SongTile> widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchText.addListener((){

      if(searchText.text.isEmpty){
        setState(() {
          widgets.clear();
        });
      }else{
        List<SongModel> songList = App.allSongs.where((song) => song.title.toLowerCase().contains(searchText.text.toLowerCase())).toList();

        List<SongTile> tile = [];
        for(final i in songList){
          tile.add(SongTile(song: i, list: 'none', searchText: searchText.text,));
        }
        setState(() {
          widgets = tile;
        });
      }

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = AppBar(
      backgroundColor: const Color(0xff5C1C14),
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.white,size: 25,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: TextField(
        autofocus: true,
        controller: searchText,
        cursorColor: Colors.white,
        style: const TextStyle(
            height: 0.8,
            fontFamily: "Orelega",
            fontSize: 20,
            color: Colors.white
        ),
        onTap: (){
          // setState(() {
          //   label = "";
          // });
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff5C1C14),
          focusColor: const Color(0xff5C1C14),
          labelText: "Search",
          labelStyle: const TextStyle(
              fontFamily: "Orelega",
              fontSize: 20,
              color: Colors.white38
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5C1C14),width: 2),
              borderRadius: BorderRadius.circular(10)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5C1C14),width: 2),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff5C1C14),width: 2),
              borderRadius: BorderRadius.circular(10)
          ),
        ),
      ),
    );

    final window = Column(
      children: widgets
    );

    return Scaffold(
      appBar: bar,
      backgroundColor: const Color(0xff781F15),
      body: SingleChildScrollView(
        child: window,
      ),
    );
  }

}