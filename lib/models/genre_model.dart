class GenreModel {
  final int id;
  String genre;
  GenreModel({
    required this.id,
    required this.genre,
  });

  @override
  String toString() {
    return "Id: $id as Genre: $genre";
  }
}
