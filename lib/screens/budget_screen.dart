import 'package:flutter/material.dart';
import '../core/theme.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  double _budgetLimit = 2000.0;
  double _currentSpending = 1250.0; // Mock data for now
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    final double progress = (_currentSpending / _budgetLimit).clamp(0.0, 1.0);
    final bool isOverBudget = _currentSpending > _budgetLimit;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget & Alerts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Budget Overview Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isOverBudget
                      ? Colors.redAccent.withOpacity(0.5)
                      : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Monthly Budget',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      Icon(
                        Icons.account_balance_wallet,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${_budgetLimit.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[800],
                    color: isOverBudget ? Colors.red : AppTheme.primaryColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spent: \$${_currentSpending.toStringAsFixed(0)}',
                        style: TextStyle(
                          color:
                              isOverBudget ? Colors.redAccent : Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Set Budget Section
            const Text(
              'Set Budget Limit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('\$0'),
                      Text(
                        '\$${_budgetLimit.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const Text('\$5000+'),
                    ],
                  ),
                  Slider(
                    value: _budgetLimit,
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    label: _budgetLimit.round().toString(),
                    activeColor: AppTheme.primaryColor,
                    onChanged: (double value) {
                      setState(() {
                        _budgetLimit = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Alerts Section
            const Text(
              'Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle:
                        const Text('Get notified when you near your limit'),
                    value: _pushNotifications,
                    activeColor: AppTheme.primaryColor,
                    secondary: const Icon(Icons.notifications_active),
                    onChanged: (bool value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                  Divider(color: Colors.grey[800], height: 1),
                  SwitchListTile(
                    title: const Text('Email Alerts'),
                    subtitle: const Text('Receive weekly summary emails'),
                    value: _emailAlerts,
                    activeColor: AppTheme.primaryColor,
                    secondary: const Icon(Icons.email),
                    onChanged: (bool value) {
                      setState(() {
                        _emailAlerts = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
