import 'package:flutter/material.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
import 'package:riverpod/riverpod.dart';

class ListSection extends StatelessWidget {
  final String title;
  final AsyncValue<List<Product>> asyncValue;
  final Widget Function(BuildContext, Product) itemBuilder;
  final VoidCallback onSeeAll;

  const ListSection({
    super.key,
    required this.title,
    required this.asyncValue,
    required this.itemBuilder,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: onSeeAll,
              child: const Text("See All"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        asyncValue.when(
          data: (products) {
            if (products.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "No products to show.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              );
            }
            // Use ListView.separated for nice dividers
            return ListView.separated(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return itemBuilder(context, products[index]);
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(
            child: Text("Error loading data: ${e.toString()}"),
          ),
        ),
      ],
    );
  }
}