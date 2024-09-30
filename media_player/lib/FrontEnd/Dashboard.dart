import 'package:flutter/material.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:media_player/FrontEnd/Dashboard/FavouriteView.dart';
import 'package:media_player/FrontEnd/Dashboard/RecentView.dart';
import 'package:media_player/FrontEnd/PlaylistSongs.dart';

import '../BackEnd/App.dart';
import 'Dashboard/PlaylistView.dart';

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
    controller = TabController(length: 3, vsync: this,initialIndex: currentIndex,animationDuration: Duration(milliseconds: 100));
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
                  controller.animateTo(0);
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
                  controller.animateTo(1);
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
                  controller.animateTo(2);
                  setState(() {
                    currentIndex = 2;
                  });
                },
              )
            ),
          ],
        ),
        Row(
          children: [
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
            Visibility(
              visible: currentIndex == 1,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      color: const Color(0xff510723),
                      child: const Icon(Icons.add,size: 28,color: Colors.white,weight: 0.1,)
                  ),
                  onTap: ()async{
                    String name = await Navigator.push(context, DialogRoute(context: context, builder: (context) => const NewPlaylistDialog()));

                    if(name.isNotEmpty){
                      await App.createPlaylist(name).then((val){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistSongs(playlist: Playlist(name: '${name}_playlist'))));
                      });
                    }

                  },
                )
              )
            )
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: const [
              RecentView(),
              PlaylistView(),
              FavouriteView()
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