import 'package:flutter/material.dart';
import 'package:media_player/BackEnd/App.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'Components.dart';

class SearchMedia extends StatefulWidget{
  final String mediaType;
  const SearchMedia({super.key,required this.mediaType});

  @override
  State<SearchMedia> createState() => _SearchMediaState();
}

class _SearchMediaState extends State<SearchMedia>{
  final searchText = TextEditingController();
  ValueNotifier<List<Widget>> widgets = ValueNotifier([]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchText.addListener((){

      App.searchMedia(searchText.text, widget.mediaType);

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

    final window = Container(
      padding: const EdgeInsets.all(0),
      child: ValueListenableBuilder(
        valueListenable: App.searchWidgets,
        builder: (context,value,child){
          return ListView(
            itemExtent: widget.mediaType == "song"? null : 80,
            children: value,
          );
        }
      )
    );

    return Scaffold(
      appBar: bar,
      backgroundColor: const Color(0xff781F15),
      body: window
    );
  }

}