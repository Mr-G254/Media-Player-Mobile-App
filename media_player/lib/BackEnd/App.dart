import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class App{
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> allSongs = [];
  static List<SongTile> songDisplay= [];
  static List<String> allVideos = [];

  static Future<void> initialize()async{
    await _audioQuery.checkAndRequest(retryRequest: true);
    allSongs = await _audioQuery.querySongs();

    allSongs.forEach((val){
      if(val.isMusic == true){
        songDisplay.add(SongTile(song: val));
      }

    });

  }
}