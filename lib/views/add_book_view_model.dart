import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/services/calculator.dart';
import 'package:firestore_exam/services/database.dart';
import 'package:flutter/cupertino.dart';

class AddBookViewModel extends ChangeNotifier {
  final DataBase _database = DataBase();
  String collectionPath = "books";

  ///Yeni kitap ekleme
  Future<void> addNewBook(
      {String? bookName, String? authorName, DateTime? publishDate}) async {
    //Form alanındaki veriler ile book objesi oluşturacak
    Book newBook = Book(
      id: DateTime.now().toIso8601String(),
      bookName: bookName,
      authorName: authorName,
      publishDate: Calculator.dateTimeToTimestamp(publishDate!),
      borrows: [],
    );

    //Bu kitap bilgisine database servisi üzerinden Firestore'a yazacak
    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
