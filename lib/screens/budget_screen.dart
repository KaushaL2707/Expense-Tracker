import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TransactionService _transactionService = TransactionService();
  double _budgetLimit = 0.0;
  double _currentSpending = 0.0;
  bool _isLoading = false;
  bool _pushNotifications = false;
  bool _emailAlerts = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final now = DateTime.now();
    final formattedMonth = DateFormat('yyyy-MM').format(now);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) return;

      // Fetch Budget
      final budget = await _transactionService.getBudget(
          userProvider.user!.id, formattedMonth);

      // Fetch Analytics for spending
      final analytics = await _transactionService.getAnalytics(
          userProvider.user!.id, formattedMonth);

      setState(() {
        _budgetLimit = budget?.amount ?? 0.0;
        _currentSpending = (analytics['totalExpense'] as num).toDouble();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching budget data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBudget(String value) async {
    final amount = double.tryParse(value);
    if (amount == null) return;

    final now = DateTime.now();
    final formattedMonth = DateFormat('yyyy-MM').format(now);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.user == null) return;

      final updatedBudget = await _transactionService.setBudget(
          userProvider.user!.id, amount, formattedMonth);
      setState(() {
        _budgetLimit = updatedBudget.amount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget updated successfully')),
      );
    } catch (e) {
      print('Error setting budget: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update budget: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double progress = (_currentSpending / _budgetLimit).clamp(0.0, 1.0);
    final bool isOverBudget = _currentSpending > _budgetLimit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Alerts'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================= BUDGET OVERVIEW CARD =======================
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isOverBudget
                            ? theme.colorScheme.error.withOpacity(0.5)
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Budget',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.account_balance_wallet,
                                color: theme.colorScheme.primary),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // BUDGET AMOUNT
                        Text(
                          '\$${_budgetLimit.toStringAsFixed(0)}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // PROGRESS BAR
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: theme.dividerColor.withOpacity(0.2),
                          color: isOverBudget
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),

                        const SizedBox(height: 12),

                        // SPENT + PERCENT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spent: \$${_currentSpending.toStringAsFixed(0)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isOverBudget
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                              ),
                            ),
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        if (!isOverBudget)
                          Text(
                            'Remaining: \$${(_budgetLimit - _currentSpending).toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ======================= SET BUDGET SECTION =======================
                  Text(
                    'Set Budget Limit',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter Monthly Budget",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: _budgetLimit.toStringAsFixed(0),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: "\$ ",
                            filled: true,
                            fillColor: theme.colorScheme.surfaceVariant
                                .withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: "Enter amount",
                          ),
                          onFieldSubmitted: (value) {
                            _updateBudget(value);
                          },
                          onChanged: (value) {
                            // Optional: update local state immediately if desired,
                            // but usually better to wait for submit or debounce.
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ======================= ALERTS SECTION =======================
                  // Text(
                  //   'Alerts',
                  //   style: theme.textTheme.titleLarge?.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  // const SizedBox(height: 16),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: theme.colorScheme.surface,
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       SwitchListTile(
                  //         title: const Text('Push Notifications'),
                  //         subtitle: const Text(
                  //             'Get notified when nearing your budget limit'),
                  //         value: _pushNotifications,
                  //         onChanged: (bool value) {
                  //           setState(() {
                  //             _pushNotifications = value;
                  //           });
                  //         },
                  //         activeColor: theme.colorScheme.primary,
                  //         secondary: const Icon(Icons.notifications_active),
                  //       ),
                  //       Divider(color: theme.dividerColor, height: 1),
                  //       SwitchListTile(
                  //         title: const Text('Email Alerts'),
                  //         subtitle: const Text('Receive weekly summary emails'),
                  //         value: _emailAlerts,
                  //         onChanged: (bool value) {
                  //           setState(() {
                  //             _emailAlerts = value;
                  //           });
                  //         },
                  //         activeColor: theme.colorScheme.primary,
                  //         secondary: const Icon(Icons.email),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }
}
