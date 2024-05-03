import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:scalex_book/Models/BooksModel.dart';

class BookLibraryViewModel extends ChangeNotifier {
  List<BooksModel> books = [];
  List<BooksModel> searchList = [];

  refresh() {
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://openlibrary.org/people/mekBot/books/already-read.json'));

    if (response.statusCode == 200) {
      BookLibraryResponse x = BookLibraryResponse.fromJson(
        jsonDecode(response.body),
      );

      books = x.books;
      refresh();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> searchBooks(String query) async {
    final response = await http
        .get(Uri.parse('https://openlibrary.org/search.json?title=$query'));

    if (response.statusCode == 200) {
      /*  final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> docs = data['docs']; */
      BookLibraryResponse x = BookLibraryResponse.fromJson(
        jsonDecode(response.body),
      );
      searchList = x.searchBooks;
      refresh();
    } else {
      throw Exception('Failed to search books');
    }
  }
}
