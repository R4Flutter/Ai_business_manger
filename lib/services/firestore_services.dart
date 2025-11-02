

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:hack_this_fall_25/model/Transaction_model.dart' as model;


class FirestoreService {
  static final _db = firestore.FirebaseFirestore.instance;

  static Future<void> saveTransaction(model.Transaction txn, {String? uid}) async {
    final userId = uid ?? 'demoUser';
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txn.transactionId);

    await docRef.set(txn.toMap());
  }
}
