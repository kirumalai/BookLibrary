import 'package:flutter/material.dart';

import 'package:scalex_book/Screen/BookLibraryPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Book Library',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BookLibraryApp(),
  ));
}
