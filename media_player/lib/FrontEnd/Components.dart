import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongTile extends StatelessWidget{
  const SongTile({super.key});

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xff510723),
              borderRadius: BorderRadius.circular(6)
            ),
            child: const Image(
              image: AssetImage("icons/wave.png"),
              height: 30,
              width: 30,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "Runaway Kanye West",
                    style: TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "04:51",
                    style: TextStyle(
                      fontFamily: "Orelega",
                      fontSize: 17,
                      color: Colors.white54,
                    ),
                  ),
                )
              ],
            ),
          ),
          // const Expanded(child: SizedBox()),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Image(
                image: AssetImage("icons/menu.png"),
                width: 30,
                height: 30,
              )
            ),
          )
        ],
      ),
    );
  }
}