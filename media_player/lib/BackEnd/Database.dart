import 'package:on_audio_query/on_audio_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class AppDatabase{
  static late Database db;
  static List<String> recentSongs = [];
  static List<String> favouriteSongs = [];

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

  static Future<void> editRecentSongs(List<SongModel> songs)async{
    db.execute('DROP TABLE IF EXISTS Recent');
    await db.execute('CREATE TABLE Recent (id INTEGER PRIMARY KEY, path TEXT)');

    for(final i in songs){
      await db.insert('Recent', {'path' : i.data});
    }

  }

  static Future<void> addFavouriteSong(String path)async{
    await db.insert('Favourite', {'path' : path});
    await getFavouriteSongs();
  }

  static Future<void> deleteFavouriteSong(String path)async{
    await db.delete('Favourite',where: 'path = ?',whereArgs: [path]);
    await getFavouriteSongs();
  }

  static void close(){
    db.close();
  }
}