import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_exam/views/books_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future getData() async {}

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>(
      initialData: null,
      create: (_) =>
          FirebaseFirestore.instance.collection("kitaplar").snapshots(),
      child: MaterialApp(
        home: BooksView(),
      ),
    );
  }
}
