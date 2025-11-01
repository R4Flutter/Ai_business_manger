import 'package:flutter/material.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
import 'package:intl/intl.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  final bool isLowStock;

  const ProductListTile({
    super.key,
    required this.product,
    this.isLowStock = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        // Placeholder for product image
        child: product.imageUrl != null
            ? Image.network(product.imageUrl!, fit: BoxFit.cover)
            : const Icon(Icons.inventory_2_outlined, color: Colors.grey),
      ),
      title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Price: ${currencyFormat.format(product.salePrice)}"),
      trailing: Text(
        "Stock: ${product.quantity}",
        style: TextStyle(
          color: isLowStock ? Colors.red : Colors.black87,
          fontWeight: isLowStock ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      onTap: () {
        // TODO: Navigate to Product Detail Screen
      },
    );
  }
}