// lib/screens/inventory_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
// 1. Import your "Add Item" screen
import 'package:hack_this_fall_25/Widgets/Inventory/Add_items_inventory.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This stream listens to the SAME path your "Add" screen writes to
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('users')
        .doc('demoUserId') // TODO: Must be the same user ID
        .collection('products')
        .orderBy('dateAdded', descending: true) // Show newest first
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('My Inventory')),
      // 2. This is the '+' icon button you asked for
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 3. This navigates to your "Add Item" screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemsInventory()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No products found. Tap "+" to add one!'),
            );
          }

          // 4. This is the list that updates automatically
          return ListView(
  children: snapshot.data!.docs.map((DocumentSnapshot document) {
    // ---- ✅ CORRECTED CODE ----
    Map<String, dynamic> data =
        document.data()! as Map<String, dynamic>;
    // 1. Get the document ID
    String docId = document.id; 
    // 2. Use your "fromFirestore" factory
    Product product = Product.fromFirestore(data, docId); 
    // ----------------------------

              // Display each product in a Card
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Stock: ${product.quantity}  |  Category: ${product.category ?? 'N/A'}',
                  ),
                  trailing: Text(
                    '\$${product.salePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
