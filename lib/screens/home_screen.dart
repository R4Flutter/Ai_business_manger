import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Providers
import '../providers/dashboard_providers.dart';

// Widgets
import '../widgets/dashboard/kpi_card.dart';
import '../widgets/dashboard/list_section.dart';
import '../widgets/dashboard/product_list_tile.dart';
import '../widgets/dashboard/sales_chart_card.dart';
import '../widgets/voice_interaction_sheet.dart';

// Screens
import 'package:hack_this_fall_25/screens/AI_assistant_screen.dart';
import 'package:hack_this_fall_25/screens/Inventory_screen.dart';
import 'package:hack_this_fall_25/screens/Transactions_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  // Helper to format currency
  String _formatCurrency(double value) {
    return NumberFormat.simpleCurrency(locale: 'en_IN', decimalDigits: 0)
        .format(value);
  }

  // Triggers the Voice Modal
  void _onMicPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return const VoiceInteractionSheet();
      },
    );
  }

  // Screens list for bottom navigation
  late final List<Widget> _screens = [
    DashboardView(formatCurrency: _formatCurrency),
    const InventoryScreen(),
    const TransactionsScreen(),
    const AiAssistantScreen(),
  ];

  // Navigation handler
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Business Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Body switches between screens but keeps them alive
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // Floating mic button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onMicPressed(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.mic, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: "AI Assistant",
          ),
        ],
      ),
    );
  }
}

//
// ==================== DASHBOARD VIEW ====================
//
class DashboardView extends ConsumerWidget {
  final String Function(double) formatCurrency;
  const DashboardView({super.key, required this.formatCurrency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyProfit = ref.watch(dailyProfitProvider);
    final dailySales = ref.watch(dailySalesProvider);
    final dailyExpenses = ref.watch(dailyExpensesProvider);
    final topSellers = ref.watch(topSellingProductsProvider);
    final lowStock = ref.watch(lowStockProductsProvider);

    return SingleChildScrollView(
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
                  formatter: formatCurrency,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: KpiCard(
                  title: "Today's Sales",
                  asyncValue: dailySales,
                  formatter: formatCurrency,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          KpiCard(
            title: "Today's Expenses",
            asyncValue: dailyExpenses,
            formatter: formatCurrency,
            color: Colors.red,
            icon: Icons.arrow_downward,
          ),

          const SizedBox(height: 20),

          // --- Chart Section ---
          const SalesChartCard(),

          const SizedBox(height: 20),

          // --- Top Sellers List ---
          ListSection(
            title: "Top-Selling Products",
            asyncValue: topSellers,
            itemBuilder: (context, product) {
              return ProductListTile(product: product);
            },
            onSeeAll: () {},
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
            onSeeAll: () {},
          ),
        ],
      ),
    );
  }
}
