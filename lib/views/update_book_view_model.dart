import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/services/calculator.dart';
import 'package:firestore_exam/services/database.dart';
import 'package:flutter/cupertino.dart';

class UpdateBookViewModel extends ChangeNotifier {
  final DataBase _database = DataBase();
  String collectionPath = "books";

  ///Yeni kitap ekleme
  Future<void> updateBook(
      {Book? book,
      String? bookName,
      String? authorName,
      DateTime? publishDate}) async {
    //Form alanındaki veriler ile book objesi oluşturacak
    Book newBook = Book(
      id: book!.id,
      bookName: bookName,
      authorName: authorName,
      publishDate: Calculator.dateTimeToTimestamp(publishDate!),
      borrows: book.borrows,
    );

    //Bu kitap bilgisine database servisi üzerinden Firestore'a yazacak
    await _database.setBookData(
        collectionPath: collectionPath, bookAsMap: newBook.toMap());
  }
}
