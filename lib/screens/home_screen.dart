import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add 'intl' to pubspec.yaml
import '../providers/dashboard_providers.dart';
import '../widgets/dashboard/kpi_card.dart';
import '../widgets/dashboard/list_section.dart';
import '../widgets/dashboard/product_list_tile.dart';
import '../widgets/dashboard/sales_chart_card.dart';
import '../widgets/voice_interaction_sheet.dart'; // Placeholder

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Helper to format currency
  String _formatCurrency(double value) {
    return NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0).format(value);
  }

  // Triggers the Voice Modal
  void _onMicPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        // This widget will contain all the logic for
        // States 1 (Listening), 2 (Processing), and 3 (Confirmation)
        return VoiceInteractionSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all your computed data providers
    final dailyProfit = ref.watch(dailyProfitProvider);
    final dailySales = ref.watch(dailySalesProvider);
    final dailyExpenses = ref.watch(dailyExpensesProvider);
    final topSellers = ref.watch(topSellingProductsProvider);
    final lowStock = ref.watch(lowStockProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO: Navigate to Notifications Screen
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              // TODO: Add user profile image
              child: Icon(Icons.person, size: 20),
            ),
            onPressed: () {
              // TODO: Navigate to Profile/Settings Screen
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- KPI Section ---
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: "Today's Profit",
                      asyncValue: dailyProfit,
                      formatter: _formatCurrency,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KpiCard(
                      title: "Today's Sales",
                      asyncValue: dailySales,
                      formatter: _formatCurrency,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // This card is on its own row
              KpiCard(
                title: "Today's Expenses",
                asyncValue: dailyExpenses,
                formatter: _formatCurrency,
                color: Colors.red,
                icon: Icons.arrow_downward,
              ),

              const SizedBox(height: 20),

              // --- Chart Section ---
              const SalesChartCard(), // This will be a placeholder for now

              const SizedBox(height: 20),

              // --- Top Sellers List ---
              ListSection(
                title: "Top-Selling Products",
                asyncValue: topSellers,
                itemBuilder: (context, product) {
                  return ProductListTile(product: product);
                },
                onSeeAll: () {
                  // TODO: Navigate to full Top Sellers list
                },
              ),

              const SizedBox(height: 20),

              // --- Low Stock List ---
              ListSection(
                title: "Low Stock Alerts",
                asyncValue: lowStock,
                itemBuilder: (context, product) {
                  return ProductListTile(
                    product: product,
                    isLowStock: true,
                  );
                },
                onSeeAll: () {
                  // TODO: Navigate to Inventory Screen (filtered by low stock)
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onMicPressed(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.mic, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}