import 'package:flutter/material.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sales vs Expenses (Last 7 Days)",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            // 
            // This is where you'd put your 'fl_chart' widget
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Chart Placeholder\n(Add fl_chart package)",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}