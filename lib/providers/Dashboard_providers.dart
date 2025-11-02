
import 'package:hack_this_fall_25/providers/service_providers.dart';
import 'package:hack_this_fall_25/model/product_model.dart';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Helper function to check if a date is today
bool _isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

// --- KPI Providers ---

// Calculates Today's Sales
final dailySalesProvider = Provider<AsyncValue<double>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);

  return transactionsAsync.whenData((transactions) {
    double totalSales = 0.0;
    for (var tx in transactions) {
      if (tx.type == 'sale' && _isToday(tx.createdAt)) {
        totalSales += tx.total;
      }
    }
    return totalSales;
  });
});

// Calculates Today's Expenses
final dailyExpensesProvider = Provider<AsyncValue<double>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);

  return transactionsAsync.whenData((transactions) {
    double totalExpenses = 0.0;
    for (var tx in transactions) {
      if (tx.type == 'expense' && _isToday(tx.createdAt)) {
        totalExpenses += tx.total;
      }
    }
    return totalExpenses;
  });
});

// Calculates Today's Profit
final dailyProfitProvider = Provider<AsyncValue<double>>((ref) {
  final sales = ref.watch(dailySalesProvider).value ?? 0.0;
  final expenses = ref.watch(dailyExpensesProvider).value ?? 0.0;

  // This provider will update when its dependencies (sales/expenses) update
  return AsyncValue.data(sales - expenses);
});

// --- List Providers ---

// Gets Top 5 Selling Products
final topSellingProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final transactionsAsync = ref.watch(transactionsStreamProvider);
  final productsAsync = ref.watch(productsStreamProvider);

  if (transactionsAsync is AsyncLoading || productsAsync is AsyncLoading) {
    return const AsyncValue.loading();
  }
  if (transactionsAsync is AsyncError) {
    return AsyncValue.error(
      transactionsAsync.error!,
      transactionsAsync.stackTrace!,
    );
  }
  if (productsAsync is AsyncError) {
    return AsyncValue.error(productsAsync.error!, productsAsync.stackTrace!);
  }

  final transactions = transactionsAsync.value!;
  final products = productsAsync.value!;

  // Simple logic to find top sellers
  Map<String, int> productSaleCounts = HashMap();
  for (var tx in transactions) {
    if (tx.type == 'sale') {
      productSaleCounts[tx.productId] =
          ((productSaleCounts[tx.productId] ?? 0) + tx.quantity);
    }
  }

  // Sort the map by sale count
  final sortedProductIds = productSaleCounts.keys.toList()
    ..sort((a, b) => productSaleCounts[b]!.compareTo(productSaleCounts[a]!));

  // Map IDs back to full Product objects
  final productMap = {for (var p in products) p.productId: p};
  final topProducts = sortedProductIds
      .map((id) => productMap[id])
      .where((p) => p != null) // Filter out any deleted products
      .take(5)
      .toList();

  return AsyncValue.data(topProducts.cast<Product>());
});

// Gets Low Stock Products (e.g., <= 5 units)
final lowStockProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsStreamProvider);

  return productsAsync.whenData((products) {
    const lowStockThreshold = 5;
    final lowStockItems = products
        .where((p) => p.quantity <= lowStockThreshold)
        .toList();

    lowStockItems.sort((a, b) => a.quantity.compareTo(b.quantity));

    return lowStockItems;
  });
});
