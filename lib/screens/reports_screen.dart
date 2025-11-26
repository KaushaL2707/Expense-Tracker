import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:exp/widgets/monthly_category_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/transaction_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());
  final List<String> months = List.generate(
    12,
    (i) => DateFormat('MMMM').format(
      DateTime(DateTime.now().year, i + 1),
    ),
  );

  final TransactionService _transactionService = TransactionService();
  Map<String, dynamic>? _analyticsData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAnalytics();
  }

  Future<void> _fetchAnalytics() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // TODO: Get actual userId
      // Convert month name to YYYY-MM format
      final now = DateTime.now();
      final monthIndex = months.indexOf(_selectedMonth) + 1;
      final formattedMonth =
          '${now.year}-${monthIndex.toString().padLeft(2, '0')}';

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) return;

      print('Fetching analytics for: $formattedMonth');
      final data = await _transactionService.getAnalytics(
          userProvider.user!.id, formattedMonth);
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      print('Analytics Data for $_selectedMonth:');
      print(encoder.convert(data));
      setState(() {
        _analyticsData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching analytics: $e');
      // Handle error
    }
  }

  Future<void> _exportData(String type) async {
    if (type == 'csv') {
      final now = DateTime.now();
      final monthIndex = months.indexOf(_selectedMonth) + 1;
      final formattedMonth =
          '${now.year}-${monthIndex.toString().padLeft(2, '0')}';
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) return;

      final url = _transactionService.getExportUrl(
          userProvider.user!.id, formattedMonth);
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch export URL')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF Export coming soon!')),
      );
    }
  }

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
                    _fetchAnalytics();
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bar Chart Section
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_analyticsData != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SizedBox(
                  height: 320, // matches chart internal height
                  child: MonthlyCategoryBarChart(
                    categoryBreakdown: Map<String, double>.from(
                        _analyticsData!['categoryBreakdown'] ?? {}),
                    selectedMonth: _selectedMonth,
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // EXPORT SECTION
            // Text(
            //   "Export Data",
            //   style: theme.textTheme.titleLarge?.copyWith(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 16),

            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () {},
            //         icon: const Icon(Icons.picture_as_pdf),
            //         label: const Text("PDF Report"),
            //         style: ElevatedButton.styleFrom(
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           backgroundColor:
            //               theme.colorScheme.errorContainer.withOpacity(0.4),
            //           foregroundColor: theme.colorScheme.error,
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () => _exportData('csv'),
            //         icon: const Icon(Icons.table_chart),
            //         label: const Text("CSV Export"),
            //         style: ElevatedButton.styleFrom(
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           backgroundColor: Colors.green.withOpacity(0.2),
            //           foregroundColor: Colors.green,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
