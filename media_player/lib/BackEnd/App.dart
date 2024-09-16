import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class App{
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player = AudioPlayer();
  static List<SongModel> allSongs = [];
  static List<Widget> songDisplay= [];
  static List<String> allVideos = [];

  static bool musicIsPlaying = false;
  static SongModel? currentSong;
  static int? currentSongDuration;
  static double songPosition = 0.0;

  static double minDisplayHeight = 0;

  static Future<void> initialize()async{
    await _audioQuery.checkAndRequest(retryRequest: true);
    allSongs = await _audioQuery.querySongs();

    allSongs.forEach((val){
      if(val.isMusic == true){
        songDisplay.add(SongTile(song: val));
      }

    });

    songDisplay.add(SizedBox(height: minDisplayHeight));
    currentSong = allSongs[0];
    currentSongDuration = currentSong!.duration;
    player.setSourceDeviceFile(currentSong!.data);
    player.setReleaseMode(ReleaseMode.stop);

  }
  
  static void playSong(SongModel song){
    currentSong = song;
    currentSongDuration = song.duration;
    player.play(DeviceFileSource(song.data));
    musicIsPlaying = true;

  }

  static void playOrpause(){
    if(!(currentSong == null)){
      if(musicIsPlaying){
        player.pause();
        musicIsPlaying = false;
      }else{
        player.resume();
        musicIsPlaying = true;
      }
    }

  }

  static SongModel nextSong(){
    var index = allSongs.indexOf(currentSong!);

    if(index == allSongs.length - 1){
      index = 0;
    }else{
      ++index;
    }

    playSong(allSongs[index]);
    return allSongs[index];
  }

  static SongModel previousSong(){
    var index = allSongs.indexOf(currentSong!);

    if(index == 0){
      index = allSongs.length - 1;
    }else{
      --index;
    }

    playSong(allSongs[index]);
    return allSongs[index];
  }

  static void seekSong(Duration dur){
    player.seek(dur);
  }
}