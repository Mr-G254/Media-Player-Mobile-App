import 'package:audio_service/audio_service.dart';
import 'package:media_player/BackEnd/App.dart';


class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler{

  Future<void> play()async{
    App.playOrpause();

  }

  Future<void> pause()async{
    App.playOrpause();
  }

  Future<void> skipToNext()async{
    App.nextSong();
  }

  Future<void> skipToPrevious()async{
    App.previousSong();
  }

  Future<void> stop()async{
    await App.player.pause();

  }

  Future<void> seek(Duration position)async{
    App.seekSong(position);
  }
}

