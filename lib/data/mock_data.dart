import '../models/transaction_model.dart';
import '../models/user_model.dart';

final User mockUser = User(
  id: 'u1',
  name: 'Alex Doe',
  email: 'alex.doe@example.com',
  profilePictureUrl: 'https://i.pravatar.cc/150?img=11',
);

final List<Transaction> mockTransactions = [
  Transaction(
    id: 't1',
    title: 'Grocery Shopping',
    amount: 150.0,
    date: DateTime.now().subtract(const Duration(days: 1)),
    category: 'Food',
    type: TransactionType.expense,
    notes: 'Weekly groceries',
  ),
  Transaction(
    id: 't2',
    title: 'Uber Ride',
    amount: 25.50,
    date: DateTime.now().subtract(const Duration(days: 2)),
    category: 'Transport',
    type: TransactionType.expense,
  ),
  Transaction(
    id: 't3',
    title: 'Freelance Project',
    amount: 1200.0,
    date: DateTime.now().subtract(const Duration(days: 5)),
    category: 'Income',
    type: TransactionType.income,
    notes: 'Website design',
  ),
  Transaction(
    id: 't4',
    title: 'Netflix Subscription',
    amount: 15.0,
    date: DateTime.now().subtract(const Duration(days: 10)),
    category: 'Entertainment',
    type: TransactionType.expense,
  ),
  Transaction(
    id: 't5',
    title: 'Gym Membership',
    amount: 50.0,
    date: DateTime.now().subtract(const Duration(days: 12)),
    category: 'Health',
    type: TransactionType.expense,
  ),
];
