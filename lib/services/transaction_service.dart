import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class TransactionService {
  static const String baseUrl =
      'https://c849642d9914.ngrok-free.app'; // Replace with your backend URL

  Future<List<Transaction>> getTransactions(int userId) async {
    final url = Uri.parse('$baseUrl/api/transactions/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Transaction> addTransaction(
      Transaction transaction, int userId) async {
    final url = Uri.parse('$baseUrl/api/transactions');
    final body = json.encode({
      ...transaction.toJson(),
      'userId': userId,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    final url = Uri.parse('$baseUrl/api/transactions/${transaction.id}');
    final body = json.encode(transaction.toJson());

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final url = Uri.parse('$baseUrl/api/transactions/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> getAnalytics(int userId, String month) async {
    final url =
        Uri.parse('$baseUrl/api/analytics/$userId').replace(queryParameters: {
      'month': month,
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load analytics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  String getExportUrl(int userId, String month) {
    return '$baseUrl/api/reports/$userId/export?month=$month';
  }

  Future<Budget?> getBudget(int userId, String month) async {
    final url =
        Uri.parse('$baseUrl/api/budgets/$userId').replace(queryParameters: {
      'month': month,
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) return null;
        return Budget.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load budget: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Budget> setBudget(int userId, double amount, String month) async {
    final url = Uri.parse('$baseUrl/api/budgets');
    final body = json.encode({
      'userId': userId,
      'amount': amount,
      'month': month,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return Budget.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to set budget: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
