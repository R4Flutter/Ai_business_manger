import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final AsyncValue<double> asyncValue;
  final String Function(double) formatter;
  final Color color;
  final IconData icon;

  const KpiCard({
    super.key,
    required this.title,
    required this.asyncValue,
    required this.formatter,
    this.color = Colors.blue,
    this.icon = Icons.arrow_upward,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
         
          children:[
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            asyncValue.when(
              data: (value) => Row(
                children: [
                  Center(child: Icon(icon, color: color, size: 28)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Center(
                      child: Text(
                        formatter(value),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e, s) => Icon(Icons.error, color: Colors.red[700]),
            ),
          ],
        ),
      ),
    );
  }
}