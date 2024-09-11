import 'package:flutter/material.dart';

class Internet extends StatefulWidget{
  const Internet({super.key});

  @override
  State<Internet> createState() => _DashboardState();
}

class _DashboardState extends State<Internet>{
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