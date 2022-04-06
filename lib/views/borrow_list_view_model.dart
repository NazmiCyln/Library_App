import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_exam/models/borrow_info_model.dart';
import 'package:firestore_exam/services/database.dart';
import 'package:flutter/cupertino.dart';

import '../models/book_model.dart';

class BorrowListViewModel extends ChangeNotifier {
  DataBase _database = DataBase();
  String collectionPath = 'books';

  Future<void> updateBook(
      {List<BorrowInfoModel>? borrowList, Book? book}) async {
    Book newBook = Book(
      id: book!.id,
      bookName: book.bookName,
      authorName: book.authorName,
      publishDate: book.publishDate,
      borrows: borrowList,
    );

    /// bu kitap bilgisini database servisi üzerinden Firestore'a yazacak
    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }

  Future<void> deletePhoto(String photoUrl) async {
    Reference photoRef = FirebaseStorage.instance.refFromURL(photoUrl);

    await photoRef.delete();
  }
}
