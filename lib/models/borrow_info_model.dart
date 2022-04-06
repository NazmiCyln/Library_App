import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowInfoModel {
  final String? name, surname, photoUrl;
  final Timestamp? borrowDate, returnDate;

  BorrowInfoModel(
      {this.name,
      this.surname,
      this.photoUrl,
      this.borrowDate,
      this.returnDate});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "surname": surname,
      "photoUrl": photoUrl,
      "borrowDate": borrowDate,
      "returnDate": returnDate,
    };
  }

  factory BorrowInfoModel.fromMap(Map map) {
    return BorrowInfoModel(
      name: map["name"],
      surname: map["surname"],
      photoUrl: map["photoUrl"],
      borrowDate: map["borrowDate"],
      returnDate: map["returnDate"],
    );
  }
}
