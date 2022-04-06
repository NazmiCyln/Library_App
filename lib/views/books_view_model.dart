import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/services/database.dart';
import 'package:flutter/cupertino.dart';

//BookView'ın state bilgisini tutmak
//BookView arayüzünün ihtiyacı olan metotları ve hesaplamaları yapmak
//Gerekli servislerle konuşmak
class BooksViewModel extends ChangeNotifier {
  DataBase _dataBase = DataBase();

  String _collectionPath = "books";

  Stream<List<Book>> getBookList() {
    //stream<QuerySnapshot> verisini al stream<List<DocumentSnapshot>> çevir
    var streamListDocument = _dataBase
        .getBookListFromApi(_collectionPath)
        .map((querySnapshot) => querySnapshot.docs);

    //stream<List<DocumentSnapshot>> listeyi al ve stream<List<Book>> listesine dönüştür
    var streamListBook = streamListDocument.map(
        (listOfDocumentSnaps) => listOfDocumentSnaps
            .map((documentSnaps) =>
                Book.fromMap(documentSnaps.data() as Map<String, dynamic>))
            .toList());

    return streamListBook;
  }

  Future<void> deleteBook(Book book) async {
    await _dataBase.deleteDocument(referencePath: _collectionPath, id: book.id);
  }
}
