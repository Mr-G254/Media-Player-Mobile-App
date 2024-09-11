import 'package:flutter/material.dart';

class Video extends StatefulWidget{
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video>{
  @override
  Widget build(BuildContext context){
    final window = Column();

    return Container(
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      height: double.infinity,
      child: window,
    );
  }
}