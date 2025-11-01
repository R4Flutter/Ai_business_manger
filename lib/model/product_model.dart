class Product {
  final String productId;
  final String name;
  final double salePrice;
  final int quantity;
  final String? imageUrl;

  Product({
    required this.productId,
    required this.name,
    required this.salePrice,
    required this.quantity,
    this.imageUrl,
  });

  // Factory to create a Product from Firestore data
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      productId: data['productId'] ?? '',
      name: data['name'] ?? 'Unknown Product',
      salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      imageUrl: data['imageUrl'],
    );
  }
}