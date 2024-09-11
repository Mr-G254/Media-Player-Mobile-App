import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_player/FrontEnd/Components.dart';

class Music extends StatefulWidget{
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music>{

  final searchText = TextEditingController();
  String label = "Search";

  @override
  Widget build(BuildContext context){
    final window = Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: searchText,
              cursorColor: Colors.white,
              style: const TextStyle(
                height: 1,
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
                prefixIcon: const Icon(Icons.search_rounded,color: Colors.white,size: 30,),
                labelText: label,
                labelStyle: const TextStyle(
                    fontFamily: "Orelega",
                    fontSize: 20,
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
        ),
        Expanded(
          // padding: EdgeInsets.all(10),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
              SongTile(),
            ],
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(0),
      width: double.infinity,
      height: double.infinity,
      child: window,
    );
  }
}