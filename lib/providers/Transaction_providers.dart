
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import 'package:hack_this_fall_25/model/Transaction_model.dart';
import 'package:hack_this_fall_25/services/firestore_services.dart';


final transactionProvider = StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<Transaction>> {
  TransactionNotifier(): super([]);

  Future<void> addTransaction(Transaction t) async {
    // optimistic update
    state = [t, ...state];
    try {
      await FirestoreService.saveTransaction(t);
    } catch (e) {
      // on error, remove
      state = state.where((s) => s.productId != t.productId).toList();
      rethrow;
    }
  }
}
