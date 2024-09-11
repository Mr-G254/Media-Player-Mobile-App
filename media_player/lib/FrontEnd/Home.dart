import 'package:flutter/material.dart';
import 'package:media_player/FrontEnd/Dashboard.dart';
import 'Internet.dart';
import 'Music.dart';
import 'Video.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  late TabController controller;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this,initialIndex: currentIndex);
    controller.addListener((){
      setState(() {
        currentIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xff781F15),
      body: TabBarView(
        controller: controller,
        children: const [
          Dashboard(),
          Music(),
          Video(),
          Internet()
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 10,right: 20,left: 20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: const Color(0xff510723),
          child: Container(
            padding: const EdgeInsets.all(0),
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: Image(
                      image: const AssetImage("icons/dashboard.png"),
                      color: currentIndex == 0 ? null : const Color(0xffE1246B),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      currentIndex = 0;
                    });

                    controller.animateTo(currentIndex);
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: Image(
                      image: const AssetImage("icons/music.png"),
                      color: currentIndex == 1 ? null : const Color(0xffE1246B),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      currentIndex = 1;
                    });
                    controller.animateTo(currentIndex);
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: Image(
                      image: const AssetImage("icons/video.png"),
                      color: currentIndex == 2 ? null : const Color(0xffE1246B),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      currentIndex = 2;
                    });
                    controller.animateTo(currentIndex);
                  },
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20,left: 20),
                    child: Image(
                      image: const AssetImage("icons/internet.png"),
                      color: currentIndex == 3 ? null : const Color(0xffE1246B),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      currentIndex = 3;
                    });
                    controller.animateTo(currentIndex);
                  },
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}