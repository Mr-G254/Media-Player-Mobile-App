class Playlist{
  final String name;
  final List<String> songs = [];
  Playlist({required this.name});

  void addSongs(List<String> songs){
    songs.addAll(songs);
  }
}