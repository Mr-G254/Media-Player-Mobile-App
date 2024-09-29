import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_player/BackEnd/Database.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class App{
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player = AudioPlayer();

  static List<SongModel> allSongs = [];
  static List<SongModel> recentSongs = [];
  static List<SongModel> favouriteSongs = [];
  static List<SongModel> currentSongList = [];
  static List<SongModel> shuffledSongList = [];

  static List<String> allVideos = [];
  static List<Playlist> allPlaylist = [];

  static List<Widget> songDisplay= [];
  static ValueNotifier<List<Widget>> recentDisplay= ValueNotifier([]);
  static ValueNotifier<List<Widget>> favouriteDisplay= ValueNotifier([]);
  static ValueNotifier<List<PlaylistTile>> playlistDisplay= ValueNotifier([]);

  static String currentList = "all";

  static bool musicIsPlaying = false;
  static late ValueNotifier<SongModel> currentSong;
  static int? currentSongDuration;
  static double songPosition = 0.0;

  static double minDisplayHeight = 0;

  static int loop = 0;
  static bool shuffle= false;

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

    for(final i in AppDatabase.playlists){
      playlistDisplay.value.add(PlaylistTile(playlist: i));
    }

    if(recentSongs.isNotEmpty){
      currentSong = ValueNotifier<SongModel>(recentSongs[0]);
    }else{
      currentSong = ValueNotifier<SongModel>(allSongs[0]);
      addRecent(allSongs[0]);
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

  static void nextSong(){

    if(shuffle){
      if(shuffledSongList.length == allSongs.length){
        if(loop == 1){
          shuffledSongList.clear();
          nextSong();
        }else if(loop == 0){
          musicIsPlaying = false;
        }
      }else{
        var index = Random().nextInt(allSongs.length);

        while(shuffledSongList.contains(allSongs[index])){
          index = Random().nextInt(allSongs.length);
        }

        shuffledSongList.add(allSongs[index]);
        playSong(allSongs[index]);
      }

    }else{
      var index = currentSongList.indexOf(currentSong.value);

      if(index == currentSongList.length - 1){
        index = 0;
      }else{
        ++index;
      }

      playSong(currentSongList[index]);
    }
  }

  static void previousSong(){
    if(shuffle){
      if(shuffledSongList.contains(currentSong.value)){
        var index = shuffledSongList.indexOf(currentSong.value);

        if(index == 0){
          nextSong();
        }else{
          playSong(shuffledSongList[index - 1]);
        }

      }else{
        nextSong();
      }
    }else{
      var index = currentSongList.indexOf(currentSong.value);

      if(index == 0){
        index = currentSongList.length - 1;
      }else{
        --index;
      }

      playSong(currentSongList[index]);
    }

  }

  static void seekSong(Duration dur){
    player.seek(dur);
  }

  static Future<void> createPlaylist(String playlistName)async{
    await AppDatabase.createPlaylist(playlistName);

    allPlaylist.add(Playlist(name: '${playlistName}_playlist'));
    refreshPlaylistDisplay();
  }

  static Future<void> deletePlaylist(Playlist playlist)async{
    await AppDatabase.deletePlaylist(playlist.name);

    allPlaylist.remove(playlist);
    refreshPlaylistDisplay();
  }

  static Future<void> addSongsToPlaylist(String playlistName,List<SongModel> songs)async{
    await AppDatabase.addPlaylistSongs(playlistName, songs);
  }

  static Future<void> removeSongFromPlaylist(String playlistName,SongModel song)async{
    await AppDatabase.deletePlaylistSong(playlistName, song);
  }

  static Future<void> addFavourite(SongModel song)async{
    if(!(favouriteSongs.contains(song))){
      await AppDatabase.addFavouriteSong(song.data);

      favouriteSongs.add(song);
      refreshFavouriteDisplay();
    }

  }

  static void deleteFavourite(SongModel song){
    AppDatabase.deleteFavouriteSong(song.data);

    favouriteSongs.remove(song);
    refreshFavouriteDisplay();
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

  static void refreshPlaylistDisplay(){
    List<PlaylistTile> play = [];

    for(final i in allPlaylist){
      play.add(PlaylistTile(playlist: i));
    }

    playlistDisplay.value = play;
  }

  static void refreshFavouriteDisplay(){
    List<Widget> fav = [];

    for(final i in favouriteSongs){
      fav.add(SongTile(song: i, list: 'favourite',));
    }

    fav.add(SizedBox(height: minDisplayHeight));
    favouriteDisplay.value = fav;
  }

  static void close()async{
    await AppDatabase.editRecentSongs(recentSongs);

  }
}