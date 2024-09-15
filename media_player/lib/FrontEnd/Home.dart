import 'package:flutter/material.dart';
import 'package:media_player/FrontEnd/Dashboard.dart';
import '../BackEnd/App.dart';
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
    final tabs = TabBarView(
      controller: controller,
      children: const [
        Dashboard(),
        Music(),
        Video(),
        Internet()
      ],
    );

    final miniDisplay = Container(
      padding: EdgeInsets.only(right: 8,left: 8),
      height: MediaQuery.of(context).size.height/10,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: const Color(0xff5C1C14),
        child: Column(
          children: [
            Expanded(
              flex: 25,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      child: AspectRatio(
                        aspectRatio: 1/1,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          color: Color(0xff510723),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            // padding: const EdgeInsets.all(20),
                            child: const Image(
                              image: AssetImage("icons/wave.png"),
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Runaway Kanye West",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Orelega",
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Container(
                              padding: const EdgeInsets.only(top: 10,bottom: 10),
                              width: MediaQuery.of(context).size.width/2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: const Image(
                                      image: AssetImage("icons/previous.png"),
                                      color: Colors.white,
                                      height: 20,
                                      width: 20,
                                    ),

                                  ),
                                  GestureDetector(
                                    child: Image(
                                      color: Colors.white,
                                      image: AssetImage(App.musicIsPlaying ? "icons/pause2.png" : "icons/play2.png"),
                                      height: 30,
                                      width: 30,
                                    ),

                                  ),
                                  GestureDetector(
                                    child: const Image(
                                      image: AssetImage("icons/next.png"),
                                      color: Colors.white,
                                      height: 20,
                                      width: 20,
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white10,
                value: 0.8,
                minHeight: 2,
                color: Colors.white,
              )
            )
          ],
        )
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xff781F15),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(0),
            child: tabs,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(0),
            child: miniDisplay,
          )
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