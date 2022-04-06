import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/views/add_book_view.dart';
import 'package:firestore_exam/views/books_view_model.dart';
import 'package:firestore_exam/views/borrow_list_view.dart';
import 'package:firestore_exam/views/update_book_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class BooksView extends StatefulWidget {
  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BooksViewModel(),
      //provider ile yayın yapıp anında dinleneceği için hata veriyor bu yüzden
      //builder ile provider verileri yüklenince yeniden build edilip scaffol yüklenecek
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text("Kitap Listesi"),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              children: [
                StreamBuilder<List<Book>>(
                  stream: Provider.of<BooksViewModel>(context, listen: false)
                      .getBookList(),
                  builder: (context, AsyncSnapshot snapData) {
                    if (snapData.hasError) {
                      return const Center(
                        child: Text("Hata"),
                      );
                    } else {
                      if (!snapData.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        List<Book> kitapList = snapData.data;
                        return BuildListView(
                          kitapList: kitapList,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddBookView()));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class BuildListView extends StatefulWidget {
  List<Book> kitapList;

  BuildListView({required this.kitapList});

  @override
  State<BuildListView> createState() => _BuildListViewState();
}

class _BuildListViewState extends State<BuildListView> {
  bool filtrelemeDurumu = false;

  late List<Book> filrelenmisListe;

  @override
  Widget build(BuildContext context) {
    var fullList = widget.kitapList;

    print(fullList.first.borrows!.first.name);
    print(fullList.first.borrows!.first.surname);

    return Flexible(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              onChanged: (query) {
                if (query.isNotEmpty) {
                  filtrelemeDurumu = true;

                  setState(() {
                    filrelenmisListe = fullList
                        .where((book) => book.bookName!
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                } else {
                  WidgetsBinding.instance!.focusManager.primaryFocus!.unfocus();

                  setState(() {
                    filtrelemeDurumu = false;
                  });
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Kitap Adı Ara",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Flexible(
            child: ListView.builder(
              itemCount:
                  filtrelemeDurumu ? filrelenmisListe.length : fullList.length,
              itemBuilder: (context, index) {
                var list = filtrelemeDurumu ? filrelenmisListe : fullList;
                return Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await Provider.of<BooksViewModel>(context,
                                  listen: false)
                              .deleteBook(list[index]);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Sil',
                        flex: 3,
                      ),
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateBookView(book: list[index]),
                            ),
                          );
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Düzenle',
                        flex: 4,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.3,
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BorrowListView(book: list[index]),
                            ),
                          );
                        },
                        backgroundColor: Color(0xFF5AC174),
                        foregroundColor: Colors.white,
                        icon: Icons.person,
                        label: 'Kayıtlar',
                      ),
                    ],
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(list[index].bookName.toString()),
                      subtitle: Text(list[index].authorName.toString()),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
