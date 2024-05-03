import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scalex_book/Models/BooksModel.dart';

import 'package:scalex_book/viewmodel/BookLibraryViewModel.dart';

class BookLibraryApp extends StatelessWidget {
  const BookLibraryApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.blueAccent),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => BookLibraryViewModel(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BookLibraryViewModel vm;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleBookStatus(List<BooksModel> books, int index) {
    books[index].isRead = !vm.books[index].isRead;
    vm.refresh();
  }

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<BookLibraryViewModel>(context, listen: false);
    vm.fetchBooks();
    return Consumer<BookLibraryViewModel>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by title',
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            showProgressCircle(context);
                            vm.searchBooks(query);
                            removeProgressCircle(context);
                          }
                          vm.refresh();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: vm.searchList.length > 1
                      ? listBooks(vm.searchList)
                      : listBooks(vm.books))
            ],
          ),
        );
      },
    );
  }

  Widget listBooks(List<BooksModel> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            'https://covers.openlibrary.org/b/id/${books[index].coverId}-M.jpg',
            width: 50,
            height: 80,
          ),
          title: Text(books[index].title),
          subtitle: Text(
              '${books[index].author.toString()}, ${books[index].publishedYear}'),
          trailing: InkWell(
            onTap: () => toggleBookStatus(books, index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: books[index].isRead
                        ? Colors.green
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                books[index].isRead ? 'Read' : 'Unread',
                style: TextStyle(
                    color: books[index].isRead ? Colors.green : Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }

  void showProgressCircle(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
            strokeWidth: 6,
          ),
        );
      },
    );
  }

  void removeProgressCircle(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
