import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Global {
  static final CollectionReference chosenSeats =
      Firestore.instance.collection('chosen-seats');

  static final List<Timer> times = [];

  static Future<void> batchDelete(List<String> list) {
    if (list.length > 0) {
      WriteBatch batch = Firestore.instance.batch();

      return chosenSeats
          .where('__name__', whereIn: list)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((document) {
          batch.delete(document.reference);
        });

        return batch.commit();
      });
    }
  }
}
