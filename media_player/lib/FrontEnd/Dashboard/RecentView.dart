import 'package:flutter/material.dart';
import '../../BackEnd/App.dart';

class RecentView extends StatelessWidget{
  const RecentView({super.key});

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
        valueListenable: App.recentDisplay,
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