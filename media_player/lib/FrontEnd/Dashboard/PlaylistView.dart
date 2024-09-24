import 'package:flutter/material.dart';
import '../../BackEnd/App.dart';

class PlaylistView extends StatelessWidget{
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
        valueListenable: App.playlistDisplay,
        builder: (context,value,child){
          return GridView.extent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
              children: value
          );
        }
    );
  }
}