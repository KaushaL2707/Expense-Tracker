import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exp/widgets/monthly_category_chart.dart';
import '../data/mock_data.dart';
import '../models/transaction_model.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  final List<Transaction> _transactions = List.from(mockTransactions);

  final List<String> months = List.generate(
    12,
    (i) => DateFormat('MMMM').format(
      DateTime(2025, i + 1),
    ),
  );

  // TODO: Replace with real data from your transaction list
  double mockIncome = 1200;
  double mockExpense = 650;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.download),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector
            Text(
              "Monthly Overview",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMonth,
                  items: months.map((m) {
                    return DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bar Chart Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SizedBox(
                height: 320, // matches chart internal height
                child: MonthlyCategoryBarChart(
                  transactions: _transactions,
                  selectedMonth: _selectedMonth,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // EXPORT SECTION
            Text(
              "Export Data",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("PDF Report"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          theme.colorScheme.errorContainer.withOpacity(0.4),
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.table_chart),
                    label: const Text("CSV Export"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green.withOpacity(0.2),
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bar Group Builder
  BarChartGroupData _barGroupData(int x, double value, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 30,
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
