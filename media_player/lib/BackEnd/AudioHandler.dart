import 'package:audio_service/audio_service.dart';
import 'package:media_player/BackEnd/App.dart';


class AppAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler{

  // @override
  Future<void> play()async{
    App.playOrpause();

  }

  // @override
  Future<void> pause()async{
    App.playOrpause();
  }

  // @override
  Future<void> skipToNext()async{
    App.nextSong();
  }

  // @override
  Future<void> skipToPrevious()async{
    App.previousSong();
  }

  // @override
  Future<void> stop()async{
    await App.player.pause();

  }

  // @override
  Future<void> seek(Duration position)async{
    App.seekSong(position);
  }

  // @override
  Future<void> click([MediaButton? button])async{
    print(button.toString());
    switch(button){
      case MediaButton.media:
        await play();
        break;
      default:
        break;
    }

  }

}



