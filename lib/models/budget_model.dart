class Budget {
  final int? id;
  final int userId;
  final double amount;
  final String month; // YYYY-MM

  Budget({
    this.id,
    required this.userId,
    required this.amount,
    required this.month,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      month: json['month'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'amount': amount,
      'month': month,
    };
  }
}
