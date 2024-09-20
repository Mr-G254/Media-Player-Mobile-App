import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_player/BackEnd/Database.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class App{
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player = AudioPlayer();

  static List<SongModel> allSongs = [];
  static List<SongModel> recentSongs = [];
  static List<SongModel> favouriteSongs = [];
  static List<SongModel> currentSongList = [];

  static List<String> allVideos = [];

  static List<Widget> songDisplay= [];
  static ValueNotifier<List<Widget>> recentDisplay= ValueNotifier([]);
  static ValueNotifier<List<Widget>> favouriteDisplay= ValueNotifier([]);

  static String currentList = "all";

  static bool musicIsPlaying = false;
  static late ValueNotifier<SongModel> currentSong;
  static int? currentSongDuration;
  static double songPosition = 0.0;

  static double minDisplayHeight = 0;

  static Future<void> initialize()async{
    await AppDatabase.initialize();
    await _audioQuery.checkAndRequest(retryRequest: true);
    allSongs = await _audioQuery.querySongs();

    allSongs.forEach((val){
      if(val.isMusic == true){
        songDisplay.add(SongTile(song: val, list: 'all',),);
        
        if(AppDatabase.recentSongs.contains(val.data)){
          recentSongs.add(val);
          recentDisplay.value.add(SongTile(song: val, list: 'recent',));
        }

        if(AppDatabase.favouriteSongs.contains(val.data)){
          favouriteSongs.add(val);
          favouriteDisplay.value.add(SongTile(song: val, list: 'favourite',));
        }
      }

    });

    songDisplay.add(SizedBox(height: minDisplayHeight));
    recentDisplay.value.add(SizedBox(height: minDisplayHeight));

    if(recentSongs.isNotEmpty){
      currentSong = ValueNotifier<SongModel>(recentSongs[0]);
    }else{
      currentSong = ValueNotifier<SongModel>(allSongs[0]);
    }

    currentSongList = allSongs;
    currentList = "all";
    currentSongDuration = currentSong.value.duration;
    player.setSourceDeviceFile(currentSong.value.data);
    player.setReleaseMode(ReleaseMode.stop);

  }
  
  static void playSong(SongModel song){
    currentSong.value = song;
    currentSongDuration = song.duration;
    player.play(DeviceFileSource(song.data));
    musicIsPlaying = true;

    if(currentList != 'recent'){
      addRecent(song);
    }

  }

  static void playOrpause(){
    if(musicIsPlaying){
      player.pause();
      musicIsPlaying = false;
    }else{
      player.resume();
      musicIsPlaying = true;
    }

  }

  static SongModel nextSong(){
    var index = currentSongList.indexOf(currentSong.value);

    if(index == currentSongList.length - 1){
      index = 0;
    }else{
      ++index;
    }

    playSong(currentSongList[index]);
    return currentSongList[index];

  }

  static SongModel previousSong(){
    var index = currentSongList.indexOf(currentSong.value);

    if(index == 0){
      index = currentSongList.length - 1;
    }else{
      --index;
    }

    playSong(currentSongList[index]);
    return currentSongList[index];
  }

  static void seekSong(Duration dur){
    player.seek(dur);
  }

  static Future<void> addFavourite(SongModel song)async{
    await AppDatabase.addFavouriteSong(song.data);
    favouriteSongs.clear();
    favouriteDisplay.value.clear();

    for(final i in allSongs){
      if(AppDatabase.favouriteSongs.contains(i.data)){
        favouriteSongs.add(i);
        favouriteDisplay.value.add(SongTile(song: i, list: "favourite"));
      }
    }
  }

  static void deleteFavourite(SongModel song){
    AppDatabase.deleteFavouriteSong(song.data);

    final index = favouriteSongs.indexOf(song);
    favouriteDisplay.value.removeAt(index);
    favouriteSongs.remove(song);
  }

  static void addRecent(SongModel song){
    if(recentSongs.contains(song)){
      recentSongs.remove(song);
    }

    if(recentSongs.length == 15){
      recentSongs.removeAt(14);
    }

    recentSongs.insert(0, song);
    refreshRecentDisplay();
  }

  static void refreshRecentDisplay(){
    List<Widget> rec = [];

    for(final i in recentSongs){
      rec.add(SongTile(song: i, list: 'recent',));
    }

    rec.add(SizedBox(height: minDisplayHeight));
    recentDisplay.value = rec;
  }

  static void close()async{
    await AppDatabase.editRecentSongs(recentSongs);

  }
}