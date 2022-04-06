import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/services/calculator.dart';
import 'package:firestore_exam/views/add_book_view_model.dart';
import 'package:firestore_exam/views/update_book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateBookView extends StatefulWidget {
  Book book;

  UpdateBookView({required this.book});

  @override
  State<UpdateBookView> createState() => _UpdateBookViewState();
}

class _UpdateBookViewState extends State<UpdateBookView> {
  TextEditingController bookContr = TextEditingController();
  TextEditingController authorContr = TextEditingController();
  TextEditingController publishContr = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _selectedDate;

  @override
  void dispose() {
    // TODO: implement dispose
    bookContr.dispose();
    authorContr.dispose();
    publishContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bookContr.text = widget.book.bookName.toString();
    authorContr.text = widget.book.authorName.toString();
    publishContr.text = Calculator.dateTimeToString(
        Calculator.dateTimeFromTimestamp(widget.book.publishDate!));

    return ChangeNotifierProvider(
      create: (_) => UpdateBookViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text("Kitap Bilgisi Güncelle"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: bookContr,
                  decoration: const InputDecoration(
                    hintText: "Kitap Adı",
                    icon: Icon(Icons.book),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Kitap adı boş bırakılamaz";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: authorContr,
                  decoration: const InputDecoration(
                    hintText: "Yazar Adı",
                    icon: Icon(Icons.edit),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Yazar adı boş bırakılamaz";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  onTap: () async {
                    _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(-1000),
                      lastDate: DateTime.now(),
                    );
                    publishContr.text =
                        Calculator.dateTimeToString(_selectedDate!);
                  },
                  controller: publishContr,
                  decoration: const InputDecoration(
                    hintText: "Basım Tarihi",
                    icon: Icon(Icons.date_range),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Lütfen tarih seçiniz";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await Provider.of<UpdateBookViewModel>(context,
                              listen: false)
                          .updateBook(
                        book: widget.book,
                        bookName: bookContr.text,
                        authorName: authorContr.text,
                        publishDate: _selectedDate ??
                            Calculator.dateTimeFromTimestamp(
                                widget.book.publishDate!),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Güncelle"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
