import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_exam/models/borrow_info_model.dart';
import 'package:firestore_exam/views/borrow_list_view.dart';

class Book {
  final String? id, bookName, authorName;
  final Timestamp? publishDate;
  final List<BorrowInfoModel>? borrows;

  Book(
      {this.id,
      this.bookName,
      this.authorName,
      this.publishDate,
      this.borrows});

  //Firebase gönderirken map şeklinde gönderildiği için objeden mape çeviriyoruz
  Map<String, dynamic> toMap() {
    ///bookInfolardan oluşan listeyi içinde map'ler olan bir listeye çevirmemiz gerekiyor
    List<Map<String, dynamic>> borrow =
        this.borrows!.map((borrowInfo) => borrowInfo.toMap()).toList();

    return {
      "id": id,
      "bookName": bookName,
      "authorName": authorName,
      "publishDate": publishDate,
      "borrows": borrow,
    };
  }

//Mapden obje oluşturan yapıcı
  factory Book.fromMap(Map map) {
    ///maplerden oluşan listeyi dart listesine çeviriyoruz
    var borrowListAsMap = map["borrows"] as List;
    List<BorrowInfoModel> borrow = borrowListAsMap
        .map((borrowAsMap) => BorrowInfoModel.fromMap(borrowAsMap))
        .toList();

    return Book(
      id: map["id"],
      bookName: map["bookName"],
      authorName: map["authorName"],
      publishDate: map["publishDate"],
      borrows: borrow,
    );
  }
}
