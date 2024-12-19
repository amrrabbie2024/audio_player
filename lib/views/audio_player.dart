import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AmrAudioPlayer extends StatefulWidget {
  const AmrAudioPlayer({super.key});

  @override
  State<AmrAudioPlayer> createState() => _AmrAudioPlayerState();
}

double sliderValue=0;
double volumeValue=1;
bool isPlaying=false;
final audioPlayer=AudioPlayer();
Duration position=Duration.zero;
Duration duration=Duration.zero;
bool isRepeat=false;
double speed=1.0;

class _AmrAudioPlayerState extends State<AmrAudioPlayer> {

  @override
  void initState() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying=event==audioPlayer.state;
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration=event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position=event;
        sliderValue=event.inSeconds.toDouble();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Padding(
          padding:  EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(25),child: Image.asset("assets/images/sharway.jpg",width: MediaQuery.of(context).size.width,height: 280,fit: BoxFit.fill,)),
              Positioned(
                bottom: 60,
                child: Row(

                  children: [
                    InkWell(onTap: () {
                      setState(() {
                        audioPlayer.seek(Duration(seconds: sliderValue.toInt()-25));
                      });
                    },child: CircleAvatar(radius: 20,backgroundColor: Colors.blue.withOpacity(.5),child: Icon(Icons.skip_previous_rounded,color: Colors.green,),)),
                    SizedBox(width: 16,),
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (isPlaying) {
                              audioPlayer.pause();
                              //isPlaying = false;
                            }
                            else {
                              audioPlayer.play(AssetSource("sounds/sharway.mp3"));
                              //isPlaying = true;
                              //audioPlayer.resume();
                            }
                            //isPlaying=!isPlaying;
                          }
                          );
                        },
                        child: CircleAvatar(radius: 25,backgroundColor: Colors.blue.withOpacity(.5),child: Icon(isPlaying?Icons.pause:Icons.play_arrow,color: Colors.green,),)),
                    SizedBox(width: 16,),
                    InkWell(onTap: () {
                      setState(() {
                        audioPlayer.seek(Duration(seconds: sliderValue.toInt()+25));
                      });
                    },child: CircleAvatar(radius: 20,backgroundColor: Colors.blue.withOpacity(.5),child: Icon(Icons.skip_next,color: Colors.green,),)),
                  ],
                ),
              ),
              Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Slider(
                    label: "$sliderValue",
                    activeColor: Colors.orange,
                    inactiveColor: Colors.yellow,
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        sliderValue=value;
                        audioPlayer.seek(Duration(seconds: value.toInt()));
                      });
                    },value: sliderValue,)),
              Positioned(
                  bottom: 10,
                  left: 48,
                  right: 48,
                  child: Row(
                    children: [
                      Text("${position.inHours.toString().padLeft(2,"0")}:${position.inMinutes.toString().padLeft(2,"0")}:${position.inSeconds.remainder(60).toString().padLeft(2,"0")}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),),
                      Spacer(),
                      Text("${duration. inHours.toString().padLeft(2,"0")}:${duration.inMinutes.toString().padLeft(2,"0")}:${duration.inSeconds.remainder(60).toString().padLeft(2,"0")}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),)
                    ],
                  )),
              Positioned(
                  top: 15,
                  right: 25,
                  child: Row(
                    children: [
                      InkWell(onTap: () {
                        setState(() {
                          isRepeat=!isRepeat;
                          if(isRepeat){
                            audioPlayer.setReleaseMode(ReleaseMode.loop);
                          }else{
                            audioPlayer.setReleaseMode(ReleaseMode.stop);
                          }
                        });
                      },child: Icon(Icons.repeat,color: isRepeat?Colors.green:Colors.yellow,size: 32,)),
                      SizedBox(width: 8,),
                      InkWell(onTap: () {
                        setState(() {
                          if(speed < 3){
                            speed+=.5;
                          }else{
                            speed=1.0;
                          }
                          audioPlayer.setPlaybackRate(speed);
                        });
                      },child: Text("${speed} X",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                    ],
                  )
              ),
              Positioned(
                  top: 50,
                  bottom: 50,
                  right: 10,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Slider(
                      min: 0,
                      max: 5,
                      divisions: 5,
                      activeColor: Colors.green,
                      inactiveColor: Colors.blue,
                      value: volumeValue,
                      onChanged: (value) {
                        setState(() {
                          volumeValue=value;
                          audioPlayer.setVolume(volumeValue);
                        });
                      },
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //audioPlayer.pause();
    super.dispose();
  }
}
