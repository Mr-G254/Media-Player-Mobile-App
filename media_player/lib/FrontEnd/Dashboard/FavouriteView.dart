import 'package:flutter/material.dart';
import '../../BackEnd/App.dart';

class FavouriteView extends StatelessWidget{
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
        valueListenable: App.favouriteDisplay,
        builder: (context,value,child){
          return ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: value
          );
        }
    );
  }
}