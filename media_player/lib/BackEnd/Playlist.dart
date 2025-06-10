class Playlist{
  final String name;
  final List<String> songs = [];
  Playlist({required this.name});

  void addSongs(List<String> newSongs){
    songs.addAll(newSongs);
  }

  void removeSongs(List<String> removsongs){
    for(final i in removsongs){
      songs.remove(i);
    }
  }
}