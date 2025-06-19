class Book {
  final int id;
  final String title;
  final String author;
  final int year;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      year: int.parse(json['year'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'year': year,
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    int? year,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      year: year ?? this.year,
    );
  }

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, year: $year}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book &&
        other.id == id &&
        other.title == title &&
        other.author == author &&
        other.year == year;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ author.hashCode ^ year.hashCode;
  }
}