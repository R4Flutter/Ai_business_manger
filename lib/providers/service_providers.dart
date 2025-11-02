
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hack_this_fall_25/model/Transaction_model.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the raw Firebase instance
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);

// Provides the current user's ID
final uidProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).currentUser?.uid;
});

// Provides a real-time stream of all user's transactions
final transactionsStreamProvider = StreamProvider<List<Transaction>>((ref) {
  final db = ref.watch(firestoreProvider);
  final uid = ref.watch(uidProvider);

  if (uid == null) {
    return Stream.value([]);
  }

  final collection = db
      .collection('users')
      .doc(uid)
      .collection('transactions')
      .orderBy('createdAt', descending: true);

  // Map the snapshot to a List<Transaction>
  return collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Transaction.fromFirestore(doc.data()))
            .toList(),
      );
});

// Provides a real-time stream of all user's products
final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  final db = ref.watch(firestoreProvider);
  final uid = ref.watch(uidProvider);

  if (uid == null) {
    return Stream.value([]);
  }

  final collection =
      db.collection('users').doc(uid).collection('products');

  // Map the snapshot to a List<Product>
  return collection.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Product.fromFirestore(doc.data(), doc.id))
            .toList(),
      );
});