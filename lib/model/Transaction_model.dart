import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String transactionId;
  final String productId; // Simplified: in real app, this might be a list
  final String type; // 'sale' or 'expense'
  final int quantity;
  final double total;
  final DateTime createdAt;
  final String source; // 'voice' or 'manual'

  Transaction({
    required this.transactionId,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.total,
    required this.createdAt,
    required this.source,
  });

  // Factory to create a Transaction from Firestore data
  factory Transaction.fromFirestore(Map<String, dynamic> data) {
    return Transaction(
      transactionId: data['transactionId'] ?? '',
      productId: data['productId'] ?? '',
      type: data['type'] ?? 'sale',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      source: data['source'] ?? 'manual',
    );
  }
}