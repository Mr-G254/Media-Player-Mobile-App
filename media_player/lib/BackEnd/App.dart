import 'package:audioplayers/audioplayers.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class App{
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static AudioPlayer player = AudioPlayer();
  static List<SongModel> allSongs = [];
  static List<SongTile> songDisplay= [];
  static List<String> allVideos = [];

  static bool musicIsPlaying = false;
  static SongModel? currentSong;
  static double songPosition = 0.0;

  static Future<void> initialize()async{
    await _audioQuery.checkAndRequest(retryRequest: true);
    allSongs = await _audioQuery.querySongs();

    allSongs.forEach((val){
      if(val.isMusic == true){
        songDisplay.add(SongTile(song: val));
      }

    });

    player.setReleaseMode(ReleaseMode.stop);

  }
  
  static void playSong(SongModel song){
    currentSong = song;
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