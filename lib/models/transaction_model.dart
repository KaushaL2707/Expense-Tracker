enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final String? notes;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    this.notes,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']), // Assumes YYYY-MM-DD format
      category: json['category'] ?? '',
      type: json['type'].toString().toLowerCase() == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Don't include ID if it's not a valid number (e.g. UUID from local creation)
      // or if we want backend to generate it.
      // However, for updates we need it.
      // We'll let the service handle ID inclusion/exclusion or just send it if it looks like a number.
      if (int.tryParse(id) != null) 'id': int.parse(id),
      'title': title,
      'amount': amount,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'category': category,
      'type': type == TransactionType.income ? 'income' : 'expense',
      'notes': notes,
    };
  }
}
