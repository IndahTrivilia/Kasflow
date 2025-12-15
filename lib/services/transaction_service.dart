// lib/services/transaction_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'transactions';

  // =====================================
  // 1. GET TRANSACTIONS (Read)
  // =====================================
  Future<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? type, // filter by 'income' or 'expense'
  }) async {
    try {
      var query = _supabase.from(_tableName).select('*, categories(id, name, type)');

      // Add date filters if provided
      if (startDate != null) {
        query = query.gte('transaction_date', startDate.toIso8601String().split('T').first);
      }
      if (endDate != null) {
        query = query.lte('transaction_date', endDate.toIso8601String().split('T').first);
      }

      // Add type filter if provided
      if (type != null && (type == 'income' || type == 'expense')) {
        query = query.eq('type', type);
      }

      // Order by date descending, limit results
      final List<dynamic> response = await query
          .order('transaction_date', ascending: false)
          .limit(100);

      return (response)
          .map((data) => TransactionModel.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat transaksi: $e');
    }
  }

  // =====================================
  // 2. GET BALANCE SUMMARY (Analytics)
  // =====================================
  Future<double> getBalanceSummary() async {
    try {
      final transactions = await getTransactions();

      double totalBalance = 0.0;
      for (var t in transactions) {
        if (t.type == 'income') {
          totalBalance += t.amount;
        } else if (t.type == 'expense') {
          totalBalance -= t.amount;
        }
      }
      return totalBalance;
    } catch (e) {
      throw Exception('Gagal menghitung saldo: $e');
    }
  }

  // =====================================
  // 3. ADD TRANSACTION (Create)
  // =====================================
  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      await _supabase.from(_tableName).insert({
        ...data,
        'user_id': currentUser.id, // Auto-attach user_id (RLS protection)
      });
    } catch (e) {
      throw Exception('Gagal menambah transaksi: $e');
    }
  }

  // =====================================
  // 4. UPDATE TRANSACTION (Update)
  // =====================================
  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      await _supabase.from(_tableName).update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengubah transaksi: $e');
    }
  }

  // =====================================
  // 5. DELETE TRANSACTION (Delete)
  // =====================================
  Future<void> deleteTransaction(String id) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus transaksi: $e');
    }
  }

  // =====================================
  // 6. GET TRANSACTION BY ID (Detail)
  // =====================================
  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final List<dynamic> response = await _supabase
          .from(_tableName)
          .select('*, categories(id, name, type)')
          .eq('id', id)
          .limit(1);

      if (response.isEmpty) return null;

      return TransactionModel.fromJson(Map<String, dynamic>.from(response.first as Map));
    } catch (e) {
      throw Exception('Gagal memuat detail transaksi: $e');
    }
  }
}