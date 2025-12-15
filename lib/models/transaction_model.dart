// lib/models/transaction_model.dart

class TransactionModel {
  final String id; // UUID string
  final String userId; // UUID string
  final double amount; // numeric dari DB
  final String type; // 'income' atau 'expense'
  final String? description;
  final DateTime transactionDate; // date (bukan timestamp)
  final DateTime createdAt; // timestamp
  final String? categoryId; // UUID string, nullable (ON DELETE SET NULL)

  // Data tambahan dari JOIN (untuk ditampilkan di UI) - buat nullable
  final String? categoryName;
  final String? categoryType;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.description,
    required this.transactionDate,
    required this.createdAt,
    this.categoryId,
    this.categoryName,
    this.categoryType,
  });

  // Factory constructor untuk membuat TransactionModel dari data JSON Supabase
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // --- Parse id (UUID string) ---
    final String id = (json['id'] ?? '').toString();
    final String userId = (json['user_id'] ?? '').toString();

    // --- Parse amount (numeric dari DB bisa num/string) ---
    double parseAmount(Object? v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    // --- Parse date robustly ---
    DateTime parseDate(Object? v) {
      if (v == null) return DateTime.now();
      if (v is DateTime) return v;
      if (v is String) {
        final parsed = DateTime.tryParse(v);
        if (parsed != null) return parsed;
        // try parse yyyy-MM-dd
        try {
          final parts = v.split(RegExp(r'[-/]'));
          if (parts.length >= 3) {
            final y = int.parse(parts[0]);
            final m = int.parse(parts[1]);
            final d = int.parse(parts[2]);
            return DateTime(y, m, d);
          }
        } catch (_) {}
      }
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.now();
    }

    // --- Parse categories (bisa null, Map, atau List dari JOIN) ---
    String? catName;
    String? catType;
    String? catId;

    final dynamic catRaw = json['categories'] ?? json['category'];

    if (catRaw == null) {
      // no join data, coba ambil category_id field
      final dynamic rawCid = json['category_id'];
      if (rawCid != null) catId = rawCid.toString();
    } else if (catRaw is List) {
      if (catRaw.isNotEmpty) {
        final first = catRaw.first;
        if (first is Map) {
          final nameVal = first['name'];
          final typeVal = first['type'];
          catName = nameVal != null ? nameVal.toString() : null;
          catType = typeVal != null ? typeVal.toString() : null;
        }
      }
    } else if (catRaw is Map) {
      final nameVal = catRaw['name'];
      final typeVal = catRaw['type'];
      catName = nameVal != null ? nameVal.toString() : null;
      catType = typeVal != null ? typeVal.toString() : null;
    }

    // category_id dari data utama (jika ada)
    final dynamic rawCid = json['category_id'];
    if (rawCid != null && rawCid.toString().isNotEmpty) {
      catId = rawCid.toString();
    }

    // Parse description safely
    String? description;
    final descVal = json['description'];
    if (descVal != null) {
      final descStr = descVal.toString().trim();
      if (descStr.isNotEmpty) {
        description = descStr;
      }
    }

    return TransactionModel(
      id: id,
      userId: userId,
      amount: parseAmount(json['amount']),
      type: (json['type'] ?? 'expense').toString(),
      description: description,
      transactionDate: parseDate(json['transaction_date']),
      createdAt: parseDate(json['created_at']),
      categoryId: catId,
      categoryName: catName,
      categoryType: catType,
    );
  }

  // Method untuk mengubah model kembali menjadi Map (JSON) untuk dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'description': description,
      'transaction_date': transactionDate.toIso8601String().split('T').first, // yyyy-MM-dd
      'category_id': categoryId,
      // 'id', 'user_id', 'created_at' di-handle oleh database
    };
  }

  @override
  String toString() =>
      'TransactionModel(id: $id, amount: $amount, type: $type, date: $transactionDate)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TransactionModel &&
            other.id == id &&
            other.userId == userId &&
            other.amount == amount &&
            other.type == type &&
            other.transactionDate == transactionDate &&
            other.categoryId == categoryId);
  }

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      amount.hashCode ^
      type.hashCode ^
      transactionDate.hashCode ^
      (categoryId?.hashCode ?? 0);
}