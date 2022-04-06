import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator {
  ///kullanıcıdan alınan DateTime zaman biçimini Stringe çeviren method
  static String dateTimeToString(DateTime dateTime) {
    //"intl" kütüphane yardımıyla formatlanıyor
    String formatedDate = DateFormat("dd-MM-yyyy").format(dateTime);

    return formatedDate;
  }

  ///DateTime'ı Firebase'in kullandığı TimeStamp biçimine dönüştür
  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  ///TimeStamp'i DateTime biçimine dönüştür
  static DateTime dateTimeFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds*1000);
  }
}
