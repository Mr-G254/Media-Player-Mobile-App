import 'package:flutter/material.dart';
import '../BackEnd/App.dart';
import '../chewie-1.8.7/lib/chewie.dart';
import 'SearchMedia.dart';

class Video extends StatefulWidget{
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  @override
  Widget build(BuildContext context){
    final window = Column(
      children: [
        SafeArea(
          child: Container(
            padding: EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        child: TextField(
                          cursorColor: Colors.white,
                          readOnly: true,
                          enabled: false,
                          style: const TextStyle(
                              height: 0.8,
                              fontFamily: "Orelega",
                              fontSize: 20,
                              color: Colors.white
                          ),
                          onTap: (){
                            // setState(() {
                            //   label = "";
                            // });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xff5C1C14),
                            focusColor: const Color(0xff5C1C14),
                            prefixIcon: const Icon(Icons.search_rounded,color: Colors.white,size: 30,),
                            labelText: "Search",
                            labelStyle: const TextStyle(
                                fontFamily: "Orelega",
                                fontSize: 20,
                                color: Colors.white
                            ),
                            disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white,width: 2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white,width: 2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white,width: 2),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchMedia(mediaType: 'video',))),
                      )
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: App.isLoading,
                    builder: (context,value,child){
                      return Visibility(
                        maintainSize: false,
                        visible: value,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          height: 35,
                          width: 35,
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 3,
                            strokeCap: StrokeCap.round,
                          )
                        )
                      );
                    }
                )
              ],
            ),
          )
        ),
        Expanded(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: App.displayVideo,
                builder: (context,value,child){
                  return Visibility(
                    visible: value,
                    child: Expanded(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color(0xff5C1C14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 20,
                        child: ValueListenableBuilder(
                          valueListenable: App.videoUI,
                          builder: (context,value,child){
                            return value != null ? Chewie(controller: value) : SizedBox();
                          },
                        ),
                      )
                    )

                  );
                }
              ),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: App.videoDisplay,
                  builder: (context,value,child){
                    return ListView(
                      padding: EdgeInsets.zero,
                      itemExtent: 85,
                      cacheExtent: double.infinity,
                      children: value,
                    );
                  }
                ),
              )
            ],
          )
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      height: double.infinity,
      child: window,
    );
  }
}