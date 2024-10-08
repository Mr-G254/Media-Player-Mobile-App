class Playlist{
  final String name;
  final List<String> songs = [];
  Playlist({required this.name});

  void addSongs(List<String> newSongs){
    songs.addAll(newSongs);
  }

  void removeSongs(List<String> songs){
    for(final i in songs){
      songs.remove(i);
    }
  }
}