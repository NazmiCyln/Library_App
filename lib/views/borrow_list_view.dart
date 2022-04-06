import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_exam/models/book_model.dart';
import 'package:firestore_exam/models/borrow_info_model.dart';
import 'package:firestore_exam/views/books_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/calculator.dart';
import 'borrow_list_view_model.dart';

class BorrowListView extends StatefulWidget {
  final Book book;

  BorrowListView({required this.book});

  @override
  State<BorrowListView> createState() => _BorrowListViewState();
}

class _BorrowListViewState extends State<BorrowListView> {
  @override
  Widget build(BuildContext context) {
    List<BorrowInfoModel>? borrowList = widget.book.borrows;

    return ChangeNotifierProvider(
      create: (context) => BorrowListViewModel(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${widget.book.bookName} Ödünç Listesi"),
          ),
          body: ListView.separated(
            itemCount: borrowList!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.blueGrey,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage("${borrowList[index].photoUrl}"),
                ),
                title: Text(
                    "${borrowList[index].name} ${borrowList[index].surname}"),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              BorrowInfoModel newBorrowInfo = await showModalBottomSheet(
                context: context,
                enableDrag: false,
                isDismissible: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: BorrowForm(),
                  );
                },
              );

              if (newBorrowInfo != null) {
                setState(() {
                  borrowList.add(newBorrowInfo);
                });
                Provider.of<BorrowListViewModel>(context, listen: false)
                    .updateBook(book: widget.book, borrowList: borrowList);
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class BorrowForm extends StatefulWidget {
  @override
  State<BorrowForm> createState() => _BorrowFormState();
}

class _BorrowFormState extends State<BorrowForm> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController surnameCtr = TextEditingController();
  TextEditingController borrowDateCtr = TextEditingController();
  TextEditingController returnDateCtr = TextEditingController();
  late DateTime _selectedBorrowDate, _selectedReturnDate;

  final _formKey = GlobalKey<FormState>();

  String? _photoUrl;

  File? _image;

  Future<void> getImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxHeight: 400,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Resim Seçmediniz");
      }
    });

    if (pickedFile != null) {
      _photoUrl = await uploadImageToStorage(_image!);
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    ///Storage üzerindeki dosya adını oluştur
    String path = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    ///Dosyayı gönder
    var uploadTask = await FirebaseStorage.instance
        .ref()
        .child("photos")
        .child(path)
        .putFile(_image!);

    String uploadedImageUrl = await uploadTask.ref.getDownloadURL();

    return uploadedImageUrl.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameCtr.dispose();
    surnameCtr.dispose();
    borrowDateCtr.dispose();
    returnDateCtr.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BorrowListViewModel(),
      builder: (context, child) => Container(
        padding: EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          child: (_image == null)
                              ? Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/firestorexam.appspot.com/o/photos%2Favatar3.png?alt=media&token=6f77e006-7737-4e03-bc57-79d38af8427e",
                                  height: 60,
                                )
                              : Image.file(_image!, height: 60),
                          radius: 40,

                          // (imageFile == null) ? NetworkImage("") : NetworkImage(""),
                        ),
                        Positioned(
                          bottom: -5,
                          right: -10,
                          child: IconButton(
                            onPressed: getImage,
                            icon: Icon(
                              Icons.photo_camera_rounded,
                              color: Colors.grey.shade100,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameCtr,
                          decoration: const InputDecoration(
                            hintText: "Ad",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Ad Giriniz";
                            } else
                              return null;
                          },
                        ),
                        TextFormField(
                          controller: surnameCtr,
                          decoration: InputDecoration(
                            hintText: "Soyad",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Soyad Giriniz";
                            } else
                              return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextFormField(
                        onTap: () async {
                          _selectedBorrowDate = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365))))!;

                          borrowDateCtr.text =
                              Calculator.dateTimeToString(_selectedBorrowDate);
                        },
                        controller: borrowDateCtr,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          hintText: 'Alım Tarihi',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Tarih Seçiniz';
                          } else {
                            return null;
                          }
                        }),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                        onTap: () async {
                          _selectedReturnDate = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365))))!;

                          returnDateCtr.text =
                              Calculator.dateTimeToString(_selectedReturnDate);
                        },
                        controller: returnDateCtr,
                        decoration: const InputDecoration(
                            hintText: 'İade Tarihi',
                            prefixIcon: Icon(Icons.date_range)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen Tarih Seçiniz';
                          } else {
                            return null;
                          }
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          /// kulanıcı bilgileri ile BorrowInfo objesi oluşturacağız
                          BorrowInfoModel newBorrowInfo = BorrowInfoModel(
                            name: nameCtr.text,
                            surname: surnameCtr.text,
                            borrowDate: Calculator.dateTimeToTimestamp(
                                _selectedBorrowDate),
                            returnDate: Calculator.dateTimeToTimestamp(
                                _selectedBorrowDate),
                            photoUrl: _photoUrl ??
                                "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/user.png?alt=media&token=2a6da58f-a35f-40f9-89f7-063f1025dce3",
                          );

                          /// navigator.pop
                          Navigator.pop(context, newBorrowInfo);
                        }
                      },
                      child: Text('ÖDÜNÇ KAYIT EKLE')),
                  ElevatedButton(
                    onPressed: () {
                      if (_photoUrl != null) {
                        Provider.of<BorrowListViewModel>(context, listen: false)
                            .deletePhoto(_photoUrl!);
                      }

                      Navigator.pop(context);
                    },
                    child: Text("İptal Et"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
