import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
import 'package:uuid/uuid.dart';

class AddItemsInventory extends StatefulWidget {
  const AddItemsInventory({super.key});

  @override
  State<AddItemsInventory> createState() => _AddItemsInventoryState();
}

class _AddItemsInventoryState extends State<AddItemsInventory> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        productId: const Uuid().v4(),
        name: _nameController.text,
        purchasePrice: double.parse(_purchasePriceController.text),
        salePrice: double.parse(_sellingPriceController.text),
        quantity: int.parse(_stockController.text),
        category: _categoryController.text.isEmpty
            ? null
            : _categoryController.text,
        dateAdded: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc('demoUserId') // TODO: Replace with actual user ID
          .collection('products')
          .doc(product.productId)
          .set(product.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: _purchasePriceController,
                decoration: const InputDecoration(labelText: 'Purchase Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter purchase price' : null,
              ),
              TextFormField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(labelText: 'Selling Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter selling price' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter stock quantity' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
