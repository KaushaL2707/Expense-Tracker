import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class MonthlyCategoryBarChart extends StatelessWidget {
  final List<Transaction> transactions;
  final String selectedMonth;

  const MonthlyCategoryBarChart({
    super.key,
    required this.transactions,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // CATEGORY COLORS
    final Map<String, Color> categoryColorMap = {
      'Food': Colors.orange,
      'Transport': Colors.blue,
      'Shopping': Colors.pink,
      'Entertainment': Colors.purple,
      'Bills': Colors.red,
      'Health': Colors.green,
      'Salary': Colors.teal,
      'Investment': Colors.indigo,
      'Other': Colors.grey,
    };

    // Month number
    final monthIndex =
        DateTime.parse("2025-${_monthNumber(selectedMonth)}-01").month;

    // SUM EXPENSE BY CATEGORY FOR SELECTED MONTH
    final Map<String, double> categoryTotals = {};

    for (var t in transactions) {
      if (t.type == TransactionType.expense && t.date.month == monthIndex) {
        categoryTotals[t.category] =
            (categoryTotals[t.category] ?? 0) + t.amount;
      }
    }

    if (categoryTotals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            "No expenses this month.",
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    final maxValue = categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          // -------- ACTUAL BAR CHART -------- //
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue + (maxValue * 0.3),
                barTouchData: BarTouchData(enabled: true),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < categoryTotals.length) {
                          return Text(
                            categoryTotals.keys.elementAt(index),
                            style: theme.textTheme.bodySmall,
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(categoryTotals.length, (i) {
                  final category = categoryTotals.keys.elementAt(i);
                  final amount = categoryTotals[category]!;
                  final color = categoryColorMap[category] ?? Colors.grey;

                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: amount,
                        color: color,
                        width: 22,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          // -------- LABELS ABOVE BARS -------- //
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(categoryTotals.length, (i) {
                    final category = categoryTotals.keys.elementAt(i);
                    final amount = categoryTotals[category]!;

                    // Position label slightly above the bar
                    final barHeight =
                        (amount / (maxValue + maxValue * 0.3)) * 240;

                    return SizedBox(
                      width: width / categoryTotals.length,
                      child: Column(
                        children: [
                          SizedBox(height: 260 - barHeight),
                          Text(
                            "\$${amount.toStringAsFixed(0)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _monthNumber(String name) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return (months.indexOf(name) + 1).toString().padLeft(2, '0');
  }
}
