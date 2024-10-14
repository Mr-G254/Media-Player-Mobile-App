import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../BackEnd/App.dart';
import 'Home.dart';

class Splashscreen extends StatefulWidget{
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>{

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    initialize();

  }

  void initialize()async{
    await App.initialize().then((val){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // timer.cancel();
  }

  @override
  Widget build(BuildContext context){
    App.minDisplayHeight = MediaQuery.of(context).size.height/10;

    const window = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage("icons/wave.png"),
          height: 150,
          width: 150,
        ),
        SizedBox(height: 30,),
        Text(
          "Media Player",
          style: TextStyle(
            fontFamily: "Orelega",
            fontSize: 35,
            color: Colors.white,
            // fontWeight: FontWeight.w100
          ),
        )
      ],
    );

    return const Scaffold(
      backgroundColor: Color(0xff510723),
      body: Center(
        child: window,
      ),
    );
  }
}