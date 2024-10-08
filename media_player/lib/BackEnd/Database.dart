import 'package:media_player/BackEnd/Playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class AppDatabase{
  static late Database db;
  static List<String> recentSongs = [];
  static List<String> favouriteSongs = [];
  static List<Playlist> playlists = [];

  static Future<void> initialize()async{
    String path = p.join(await getDatabasesPath(),"App.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db,ver){
        firstTimeSetup(db);
      }
      // onCreate:
    );

    await getRecentSongs();
    await getFavouriteSongs();
    await getPlaylists();
  }

  static Future<void> firstTimeSetup(Database database)async{
    await database.execute('CREATE TABLE Recent (id INTEGER PRIMARY KEY, path TEXT)');
    await database.execute('CREATE TABLE Favourite (id INTEGER PRIMARY KEY, path TEXT)');
  }

  static Future<void> getRecentSongs()async{
    var list = await db.query('Recent',columns: ['path']);

    recentSongs.clear();
    for(final i in list){
      recentSongs.add(i['path'] as String);
    }

  }

  static Future<void> getFavouriteSongs()async{
    var list = await db.query('Favourite',columns: ['path']);

    favouriteSongs.clear();
    for(final i in list){
      favouriteSongs.add(i['path'] as String);
    }
  }

  static Future<void> getPlaylists()async{
    playlists.clear();
    var list = await db.rawQuery('SELECT name FROM sqlite_master WHERE type = "table" AND name LIKE "%playlist"');

    for(final i in list){
      var playName = i['name'] as String;
      print(playName);
      final playlist = Playlist(name: playName);
      
      var songs = await getPlaylistSongs(playName);
      playlist.addSongs(songs);

      playlists.add(playlist);
    }
  }

  static Future<List<String>> getPlaylistSongs(String playlistName)async{
    var list = await db.query('[$playlistName]',columns: ['path']);
    List<String> song = [];

    for(final i in list){
      song.add(i['path'] as String);
    }

    return song;
  }

  static Future<void> editRecentSongs(List<SongModel> songs)async{
    db.execute('DROP TABLE IF EXISTS Recent');
    await db.execute('CREATE TABLE Recent (id INTEGER PRIMARY KEY, path TEXT)');

    for(final i in songs){
      await db.insert('Recent', {'path' : i.data});
    }

  }

  static Future<void> addFavouriteSong(String path)async{
    await db.insert('Favourite', {'path' : path});
    // await getFavouriteSongs();
  }

  static Future<void> deleteFavouriteSong(String path)async{
    await db.delete('Favourite',where: 'path = ?',whereArgs: [path]);
    // await getFavouriteSongs();
  }

  static Future<void> createPlaylist(String playlistName)async{
    await db.execute("CREATE TABLE '${playlistName}_playlist' (id INTEGER PRIMARY KEY, path TEXT)");
  }

  static Future<void> addPlaylistSongs(String playlistName,List<SongModel> songs)async{
    var added = songs;
    var list = await getPlaylistSongs(playlistName);

    for(final i in added){
      if(list.contains(i.data)){
        added.remove(i);
      }
    }

    for(final i in added){
      await db.insert('[$playlistName]', {'path' : i.data});
    }

  }

  static Future<void> deletePlaylistSong(String playlistName,SongModel song)async{
    await db.delete('[$playlistName]',where: 'path = ?',whereArgs: [song.data]);

  }

  static Future<void> deletePlaylist(String playlistName)async{
    await db.execute("DROP TABLE IF EXISTS '$playlistName'");
  }


  static void close(){
    db.close();
  }
}