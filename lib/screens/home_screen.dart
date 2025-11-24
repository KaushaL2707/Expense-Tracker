import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/mock_data.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import 'package:exp/widgets/expense_pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = List.from(mockTransactions);

  void _addNewTransaction(Transaction newTransaction) {
    setState(() {
      _transactions.insert(0, newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0, (sum, t) => sum + t.amount);

    final double totalExpense = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0, (sum, t) => sum + t.amount);

    final double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BALANCE CARD
              _buildBalanceCard(context, balance, totalIncome, totalExpense),

              const SizedBox(height: 32),

              // PIE CHART
              Text(
                'Spending Breakdown',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpensePieChart(transactions: _transactions),
              ),

              const SizedBox(height: 32),

              // RECENT TRANSACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: const Text('See All'),
                  // ),
                ],
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final t = _transactions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (t.type == TransactionType.income
                                ? Colors.green
                                : Colors.red)
                            .withOpacity(0.1),
                        child: Icon(
                          t.type == TransactionType.income
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      title: Text(
                        t.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMd().format(t.date),
                            style: theme.textTheme.bodyMedium,
                          ),
                          if (t.notes != null && t.notes!.isNotEmpty)
                            Text(
                              t.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall!.color!
                                    .withOpacity(0.7),
                              ),
                            ),
                        ],
                      ),
                      trailing: Text(
                        '${t.type == TransactionType.income ? '+' : '-'} \$${t.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.type == TransactionType.income
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // FAB
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: FloatingActionButton(
          onPressed: () async {
            final newTransaction = await Navigator.push<Transaction>(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );

            if (newTransaction != null) _addNewTransaction(newTransaction);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // BALANCE CARD
  Widget _buildBalanceCard(
      BuildContext context, double balance, double income, double expense) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: theme.textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                  'Income', income, Icons.arrow_downward, Colors.greenAccent),
              _buildSummaryItem(
                  'Expense', expense, Icons.arrow_upward, Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
