// ignore: file_names

class BookLibraryResponse {
  BookLibraryResponse({
    required this.books,
    required this.searchBooks,
  });

  List<BooksModel> books;
  List<BooksModel> searchBooks;

  factory BookLibraryResponse.fromJson(Map<String, dynamic> json) =>
      BookLibraryResponse(
        books: json["reading_log_entries"] == null
            ? []
            : List<BooksModel>.from(
                json["reading_log_entries"].map((x) => BooksModel.fromJson(x))),
        searchBooks: json["docs"] == null
            ? []
            : List<BooksModel>.from(
                json["docs"].map((x) => BooksModel.fromJson(x))),
      );
}

class BooksModel {
  final String title;
  final List<dynamic> author;
  final String publishedYear;
  final String coverId;
  bool isRead;

  BooksModel({
    required this.title,
    required this.author,
    required this.publishedYear,
    required this.coverId,
    this.isRead = false,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        title: checkNull(json["title"] ??
            (json["work"] == null ? "" : json["work"]["title"]) ??
            ""),
        author: (json["author_name"] ??
                (json["work"] == null ? [] : json["work"]["author_names"]) ??
                [])
            .toList(),
        publishedYear: checkNull(json["first_publish_year"] ??
            (json["work"] == null ? "" : json["work"]["first_publish_year"]) ??
            ""),
        coverId: checkNull(json["cover_i"] ??
            (json["work"] == null ? "" : json["work"]["cover_id"])),
      );
}

String checkNull(dynamic val) {
  String x = val == null ? "" : val.toString().trim();
  return x == "null" ? "" : x;
}
