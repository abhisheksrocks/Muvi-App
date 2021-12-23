class ReviewModel {
  final String id;
  final String author;
  final String content;
  int? rating;
  ReviewModel({
    required this.id,
    required this.author,
    required this.content,
    this.rating,
  });
}
