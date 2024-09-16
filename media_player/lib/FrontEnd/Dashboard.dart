import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin{
  int currentIndex = 0;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this,initialIndex: currentIndex);
    controller.addListener((){
      setState(() {
        currentIndex = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    final recent = Card(
      elevation: 5,
      color: Color(currentIndex == 0 ? 0xff5C1C14 : 0xff510723),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(currentIndex == 0 ? 30 :20),
            child: const Image(
              image: AssetImage("icons/recent.png"),
              height: 60,
              width: 60,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Recent",
              style: TextStyle(
                fontFamily: "Orelega",
                fontSize: 17,
                color: Colors.white,
                // fontWeight: FontWeight.w100
              ),
            ),
          )
        ],
      ),
    );

    final playlist = Card(
      elevation: 5,
      color: Color(currentIndex == 1 ? 0xff5C1C14 : 0xff510723),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(currentIndex == 1 ? 30 :20),
            child: const Image(
              image: AssetImage("icons/playlist.png"),
              height: 60,
              width: 60,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Playlist",
              style: TextStyle(
                fontFamily: "Orelega",
                fontSize: 17,
                color: Colors.white,
                // fontWeight: FontWeight.w100
              ),
            ),
          )
        ],
      ),
    );

    final favourite = Card(
      elevation: 5,
      color: Color(currentIndex == 2 ? 0xff5C1C14 : 0xff510723),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(currentIndex == 2 ? 30 :20),
            child: const Image(
              image: AssetImage("icons/favorite.png"),
              height: 60,
              width: 60,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Favourite",
              style: TextStyle(
                fontFamily: "Orelega",
                fontSize: 17,
                color: Colors.white,
                // fontWeight: FontWeight.w100
              ),
            ),
          )
        ],
      ),
    );

    final window = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: recent,
                onTap: (){
                  controller.animateTo(currentIndex);
                  setState(() {
                    currentIndex = 0;
                  });

                },
              )
            ),
            Expanded(
              child: GestureDetector(
                child: playlist,
                onTap: (){
                  controller.animateTo(currentIndex);
                  setState(() {
                    currentIndex = 1;
                  });
                },
              )
            ),
            Expanded(
              child: GestureDetector(
                child: favourite,
                onTap: (){
                  controller.animateTo(currentIndex);
                  setState(() {
                    currentIndex = 2;
                  });
                },
              )
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5),
          child: Text(
            currentIndex == 0 ? "Recent" : currentIndex == 1 ? "Playlist" : "Favourite",
            style: const TextStyle(
              fontFamily: "Orelega",
              fontSize: 19,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: []
              ),
              ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: []
              ),
              ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: []
              ),
            ],
          )
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(child: window),
    );
  }
}