import 'package:flutter/material.dart';
import 'package:media_player/FrontEnd/SearchMedia.dart';
import '../BackEnd/App.dart';

class Music extends StatefulWidget{
  const Music({super.key});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final searchText = TextEditingController();
  String label = "Search";

  @override
  Widget build(BuildContext context){
    final window = Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              child: TextField(
                controller: searchText,
                cursorColor: Colors.white,
                readOnly: true,
                enabled: false,
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
                  prefixIcon: const Icon(Icons.search_rounded,color: Colors.white,size: 30,),
                  labelText: label,
                  labelStyle: const TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 20,
                      color: Colors.white
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white,width: 2),
                      borderRadius: BorderRadius.circular(10)
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchMedia(mediaType: 'song',))),
            )
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: App.songDisplay,
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

    return Container(
      padding: EdgeInsets.all(0),
      width: double.infinity,
      height: double.infinity,
      child: window,
    );
  }
}