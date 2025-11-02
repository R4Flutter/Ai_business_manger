// lib/models/product_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String name;
  final double purchasePrice; // cost price
  final double salePrice; // selling price
  final int quantity;
  final String? category;
  final String? imageUrl;
  final DateTime dateAdded;

  Product({
    required this.productId,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.quantity,
    this.category,
    this.imageUrl,
    required this.dateAdded,
  });

  /// ✅ Convert Product to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
      'dateAdded': Timestamp.fromDate(dateAdded),
    };
  }

  /// ✅ Create Product object from Firestore Document
  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      productId: data['productId'] ?? docId,
      name: data['name'] ?? 'Unknown Product',
      purchasePrice: (data['purchasePrice'] as num?)?.toDouble() ?? 0.0,
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      category: data['category'],
      imageUrl: data['imageUrl'],
      dateAdded: (data['dateAdded'] is Timestamp)
          ? (data['dateAdded'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
