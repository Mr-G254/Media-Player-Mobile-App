import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:media_player/BackEnd/Database.dart';
import 'package:media_player/BackEnd/Playlist.dart';
import 'package:media_player/FrontEnd/Components.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_storage_query/video_storage_query.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';

import '../chewie-1.8.7/lib/chewie.dart';

abstract class App{
  static RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
  static OnAudioQuery _audioQuery = OnAudioQuery();
  static VideoStorageQuery videoQuery = VideoStorageQuery();
  static AudioPlayer player = AudioPlayer();
  static late BaseAudioHandler audioHandler;
  static late AudioSession session;

  static List<SongModel> allSongs = [];
  static List<SongModel> recentSongs = [];
  static List<SongModel> favouriteSongs = [];
  static List<SongModel> currentSongList = [];
  static List<SongModel> shuffledSongList = [];
  static List<SongModel> currentPlaylistSongs = [];

  static List<VideoItem> allVideos = [];
  static List<Playlist> allPlaylist = [];
  static Playlist currentPlaylist = Playlist(name: '');

  static ValueNotifier<List<Widget>> songDisplay= ValueNotifier([]);
  static ValueNotifier<List<Widget>> recentDisplay= ValueNotifier([]);
  static ValueNotifier<List<Widget>> favouriteDisplay= ValueNotifier([]);
  static ValueNotifier<List<PlaylistTile>> playlistDisplay= ValueNotifier([]);

  static ValueNotifier<List<Widget>> videoDisplay= ValueNotifier([]);
  static ValueNotifier<bool> isLoading = ValueNotifier(false);

  static String currentList = "all";

  static ValueNotifier<bool> musicIsPlaying = ValueNotifier(false);
  static late ValueNotifier<SongModel> currentSong;
  static ValueNotifier<String> currentPlaylistName = ValueNotifier('');
  static int? currentSongDuration;
  static double songPosition = 0.0;

  static double minDisplayHeight = 0;
  static double vol = 0;

  static int loop = 0;
  static bool shuffle= false;

  static VideoPlayerController? videoController;
  static ValueNotifier<ChewieController?> videoUI = ValueNotifier(null);
  static ValueNotifier<bool> displayVideo = ValueNotifier(false);
  static ValueNotifier<String> currentVideo = ValueNotifier("");

  static late Directory thumbnailDir;
  static ValueNotifier<List<String>> thumbnailsPath = ValueNotifier([]);

  static ValueNotifier<List<Widget>> searchWidgets = ValueNotifier([]);

  static YoutubeDataApi ytSearch = YoutubeDataApi();
  static ValueNotifier<String> searchTerm = ValueNotifier("");
  static ValueNotifier<List<Widget>> ytVideoWidgets = ValueNotifier([]);

  static Future<void> initialize()async{
    await AppDatabase.initialize();
    final tempDir = await getTemporaryDirectory();
    thumbnailDir = Directory(join(tempDir.path,"thumbnails"));

    if(await thumbnailDir.exists()){
      List<String> paths = [];
      final files = await thumbnailDir.list().toList();

      for(final i in files){
        if(i.path.endsWith(".jpg")){
          paths.add(i.path);
        }
      }

      thumbnailsPath.value = paths;
    }else{
      thumbnailDir.create();
    }

    await initializeAudioSession();
    await _audioQuery.checkAndRequest(retryRequest: true);
    allSongs = await _audioQuery.querySongs();

    if(Permission.videos.status != PermissionStatus.granted){
      await Permission.videos.request();
    }
    allVideos = await videoQuery.queryVideos();

    allSongs = allSongs.where((song) => song.isMusic == true).toList();

    allSongs.forEach((val){
      if(val.isMusic == true){
        songDisplay.value.add(SongTile(song: val, list: 'all', searchText: '',),);
        
        if(AppDatabase.recentSongs.contains(val.data)){
          recentSongs.add(val);
          recentDisplay.value.add(SongTile(song: val, list: 'recent', searchText: '',));
        }

        if(AppDatabase.favouriteSongs.contains(val.data)){
          favouriteSongs.add(val);
          favouriteDisplay.value.add(SongTile(song: val, list: 'favourite', searchText: '',));
        }
      }

    });

    recentSongs = recentSongs.reversed.toList();
    recentDisplay.value = recentDisplay.value.reversed.toList();

    songDisplay.value.add(SizedBox(height: minDisplayHeight));
    recentDisplay.value.add(SizedBox(height: minDisplayHeight));

    for(final i in AppDatabase.playlists){
      allPlaylist.add(i);
      playlistDisplay.value.add(PlaylistTile(playlist: i));
    }

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

    updateSongUI(currentSong.value);
    updateIsPlayingUI(false);

    for(final i in allVideos){
      videoDisplay.value.add(VideoCard(video: i, searchText: '',));
    }

    videoDisplay.value.add(SizedBox(height: (minDisplayHeight + 5),));

    if(thumbnailsPath.value.length != allVideos.length){
      final port = ReceivePort();
      var rootToken = RootIsolateToken.instance!;

      isLoading.value = true;

      await Isolate.spawn(generateThumbnails,[videoDisplay.value,port.sendPort,rootToken,thumbnailsPath.value,thumbnailDir]);

      port.listen((message){
        var thumbnailList = message as List<String>;
        var existingList = thumbnailsPath.value;

        existingList.addAll(thumbnailList);

        for(final i in existingList){
          print(i);
        }

        thumbnailsPath.value = existingList;
        isLoading.value = false;
      });
    }
  }

  static Future<void> generateThumbnails(List<Object> args)async{
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[2] as RootIsolateToken);
    List<String> existingPaths = args[3] as List<String>;
    Directory thumbnailDir = args[4] as Directory;
    List<String> processedImages = [];

    for(final i in (args[0] as List<Widget>)){
      if(i is VideoCard){
        String filename = join(thumbnailDir.path,"${i.video.name.split(".")[0]}.jpg");

        if(!(existingPaths.contains(filename))){
          var img = await VideoThumbnail.thumbnailData(video: i.video.path,quality: 1);
          var compressedImg = await FlutterImageCompress.compressWithList(img!,quality: 50,);

          var file = File(filename);
          await file.writeAsBytes(compressedImg);

          processedImages.add(filename);

        }
      }
    }

    (args[1] as SendPort).send(processedImages);
  }

  static void playSong(SongModel song){
    currentSong.value = song;
    currentSongDuration = song.duration;

    updateSongUI(currentSong.value);
    player.play(DeviceFileSource(song.data));

    musicIsPlaying.value = true;
    updateIsPlayingUI(true);

    if(currentList != 'recent'){
      addRecent(song);
    }

  }

  static void playOrpause(){
    if(musicIsPlaying.value){
      player.pause();
      musicIsPlaying.value = false;
      updateIsPlayingUI(false);

    }else{
      player.resume();
      musicIsPlaying.value = true;
      updateIsPlayingUI(true);
    }

    if(!(recentSongs.contains(currentSong.value))){
      addRecent(currentSong.value);
    }
  }

  static void nextSong(){

    if(shuffle){
      if(shuffledSongList.length == allSongs.length){
        if(loop == 1){
          shuffledSongList.clear();
          nextSong();
        }else if(loop == 0){
          musicIsPlaying.value = false;
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

    List<PlaylistTile> list = playlistDisplay.value;
    list.add(PlaylistTile(playlist: Playlist(name: '${playlistName}_playlist')));

    playlistDisplay.value = list;
  }

  static Future<void> deletePlaylist(Playlist playlist)async{
    await AppDatabase.deletePlaylist(playlist.name);

    allPlaylist.remove(playlist);
    await refreshPlaylistDisplay();
  }

  static Future<void> addSongsToPlaylist(String playlistName,List<SongModel> songs)async{
    for(final i in allPlaylist){
      if(i.name == playlistName){
        List<String> list = [];
        for(final j in songs){
          if(i.songs.contains(j.data)){
            continue;
          }

          list.add(j.data);
        }

        if(list.isNotEmpty){
          i.addSongs(list);
        }

        break;
      }
    }
    await AppDatabase.addPlaylistSongs(playlistName, songs);
  }

  static Future<void> removeSongFromPlaylist(String playlistName,SongModel song)async{
    var index = 0;
    for(final i in allPlaylist){
      if(i.name == playlistName){
        break;
      }
      ++index;
    }

    App.allPlaylist[index].removeSongs([song.data]);
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

  static void refreshSongDisplay(){
    List<Widget> song = [];

    for(final i in recentSongs){
      song.add(SongTile(song: i, list: 'recent', searchText: '',));
    }

    song.add(SizedBox(height: minDisplayHeight));
    songDisplay.value = song;
  }

  static void refreshRecentDisplay(){
    List<Widget> rec = [];

    for(final i in recentSongs){
      rec.add(SongTile(song: i, list: 'recent', searchText: '',));
    }

    rec.add(SizedBox(height: minDisplayHeight));
    recentDisplay.value = rec;
    AppDatabase.editRecentSongs(recentSongs);
  }

  static Future<void> refreshPlaylistDisplay()async{
    List<PlaylistTile> play = [];

    for(final i in allPlaylist){
      play.add(PlaylistTile(playlist: i));
    }

    playlistDisplay.value = play;
  }

  static void refreshFavouriteDisplay(){
    List<Widget> fav = [];

    for(final i in favouriteSongs){
      fav.add(SongTile(song: i, list: 'favourite', searchText: '',));
    }

    fav.add(SizedBox(height: minDisplayHeight));
    favouriteDisplay.value = fav;
  }

  static void deleteSong(SongModel song)async{
    allSongs.remove(song);

    if(recentSongs.contains(song)){
      recentSongs.remove(song);
      AppDatabase.editRecentSongs(recentSongs);
    }

    if(favouriteSongs.contains(song)){
      favouriteSongs.remove(song);
      deleteFavourite(song);
    }

    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    if(android.version.sdkInt < 30){
      var perm = await Permission.storage.status;
      if(!perm.isGranted){
        await Permission.storage.request();
      }
    }else{
      var perm = await Permission.manageExternalStorage.status;
      if(!perm.isGranted){
        await Permission.manageExternalStorage.request();
      }
    }

    var path = join(getExternalStorageDirectory().toString(),song.data);
    await File(path).delete();


    songDisplay.value = [];
    recentDisplay.value = [];
    favouriteDisplay.value = [];

    for(final val in allSongs){
      songDisplay.value.add(SongTile(song: val, list: 'all', searchText: '',),);
    }

    for(final val in favouriteSongs){
      favouriteDisplay.value.add(SongTile(song: val, list: 'favourite', searchText: '',),);
    }

    for(final i in recentSongs){
      recentDisplay.value.add(SongTile(song: i, list: 'recent', searchText: '',));
    }

    songDisplay.value.add(SizedBox(height: minDisplayHeight));
    recentDisplay.value.add(SizedBox(height: minDisplayHeight));
    favouriteDisplay.value.add(SizedBox(height: minDisplayHeight));
  }

  static void deleteVideo(VideoItem vida)async{
    var path = join(getExternalStorageDirectory().toString(),vida.path);
    await File(path).delete();

    List<Widget> vid = [];

    for(final i in videoDisplay.value){

      try{
        VideoCard video = i as VideoCard;

        if(vida.path == video.video.path){
          continue;
        }

        final remVideo = VideoCard(video: video.video, searchText: '');
        vid.add(remVideo);
      }catch(e){

      }
    }

    videoDisplay.value = vid;
  }

  static Future<void> shareMedia(String mediaTitle,String mediaPath)async{
    await AppinioSocialShare().android.shareFilesToSystem(mediaTitle, [mediaPath]);
  }
  
  static void updateSongUI(SongModel song){
    audioHandler.mediaItem.add(MediaItem(id: song.id.toString(), title: song.title,duration: Duration(milliseconds: song.duration!)));
    audioHandler.playbackState.add(audioHandler.playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
      androidCompactActionIndices: [0, 1, 2],
      controls: [
        MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.skipToPrevious
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      }
    ));
  }

  static void updateIsPlayingUI(bool isPlaying){
    audioHandler.playbackState.add(audioHandler.playbackState.value.copyWith(
      playing: isPlaying,
      controls: [
        isPlaying? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.skipToPrevious
      ],
    ));

  }

  static void updateProgressUI(Duration pos){
    audioHandler.playbackState.add(audioHandler.playbackState.value.copyWith(updatePosition: pos));
  }

  static Future<void> initializeAudioSession()async{
    session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await session.setActive(true);

  }

  /*#############################################################################*/

  static void playLocalVideo(VideoItem video,String title,{bool fullScreen = false})async{
    try{
      App.videoController?.dispose();
      App.videoUI.value?.dispose();
    }catch(e){

    }

    App.currentVideo.value = title;

    videoController = VideoPlayerController.file(File(video.path));
    await videoController?.initialize();

    displayVideo.value = true;
    videoUI.value = ChewieController(
      fullScreenByDefault: fullScreen,
      autoInitialize: true,
      showControlsOnInitialize: true,
      playbackSpeeds: [0.5,1,1.5],
      additionalOptions: (context){
        return <OptionItem>[
          OptionItem(
            onTap: (){
              shareMedia(title, video.path);
            },
            iconData: Icons.share,
            title: 'Share video'
          ),
          OptionItem(
            onTap: ()async{
              await videoUI.value?.pause();
              displayVideo.value = false;
              Navigator.pop(context);
            },
            iconData: Icons.stop_screen_share,
            title: 'Close video'
          ),
          OptionItem(
            onTap: ()async{
              Navigator.pop(context);
              videoUI.value?.pause();
              displayVideo.value = false;

              var response = await Navigator.push(context, DialogRoute(context: context, builder: (context) => AskDelete(itemToDelete: title,isSong: true,)));

              if(response) {
                App.deleteVideo(video);
              }

            },
            iconData: Icons.delete,
            title: 'Delete video'
          )
        ];
      },
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xffE1246B),
        bufferedColor: const Color(0xFFFFFFFF).withOpacity(0.2),
        handleColor: const Color(0xFFc8c8c8).withOpacity(1.0),
        backgroundColor: const Color(0xFFc8c8c8).withOpacity(1.0)
      ),
      videoPlayerController: videoController!,
      autoPlay: true,
    );

  }

  static void hideVideo(){
    displayVideo.value = false;
  }

  static void searchMedia(String searchText,String searchType){
    if(searchText.isEmpty){
      App.searchWidgets.value = [];
    }else{
      if(searchType == "song") {
        List<SongModel> songList = App.allSongs
            .where((song) =>
            song.title.toLowerCase().contains(searchText.toLowerCase()))
            .toList();

        List<Widget> tile = [];
        for (final i in songList) {
          tile.add(SongTile(song: i, list: 'none', searchText: searchText,));
        }

        App.searchWidgets.value = tile;

      }else if(searchType == 'video'){
        List<Widget> vidList = [];

        for(final i in App.videoDisplay.value){
          try{
            final vid = i as VideoCard;

            if(vid.video.name.toLowerCase().contains(searchText.toLowerCase())){

              final VideoCard resultVideo = VideoCard(video: vid.video, searchText: searchText);
              vidList.add(resultVideo);
            }
          }catch(e){

          }
        }

        App.searchWidgets.value = vidList;
      }
    }
  }

  /*################################################################################*/

  static Future<List<String>> get_Search_Suggestions (String text)async{
    List<String> suggestions = await ytSearch.fetchSuggestions(text);

    return suggestions;
  }

  static void youtubeSearch(String searchText){

  }

  static void youtubeGetTrending()async{
    List<Video> videos = await ytSearch.fetchTrendingVideo();
    List<YoutubeVideo> videoWidgets = [];

    for(final i in videos){
      videoWidgets.add(YoutubeVideo(title: i.title!, duration: i.duration!, thumbnail: i.thumbnails!));
    }

    ytVideoWidgets.value = videoWidgets;


  }
}
