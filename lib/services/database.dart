import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_exam/models/book_model.dart';

class DataBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Firestore servisinden kitapların verisini stream olarak alıp okumak
  Stream<QuerySnapshot> getBookListFromApi(String referencePath) {
    return _firestore.collection(referencePath).snapshots();
  }

  ///Firestore üzerindeki veriyi silme
  Future<void> deleteDocument({String? referencePath, String? id}) async {
    await _firestore.collection(referencePath!).doc(id).delete();
  }

  ///Firestore yeni veri ekleme ve güncelleme
  Future<void> setBookData(
      {String? collectionPath, Map<String, dynamic>? bookAsMap}) async {
    await _firestore
        .collection(collectionPath!)
        .doc(Book.fromMap(bookAsMap!).id)
        .set(bookAsMap);
  }


}
