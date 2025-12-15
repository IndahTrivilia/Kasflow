// lib/services/category_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _tableName = 'categories';

  // =====================================
  // 1. GET ALL CATEGORIES
  // =====================================
  Future<List<CategoryModel>> getCategories({String? type}) async {
    try {
      var query = _supabase.from(_tableName).select();

      // Filter by type if provided
      if (type != null && (type == 'income' || type == 'expense')) {
        query = query.eq('type', type);
      }

      final List<dynamic> response = await query.order('name', ascending: true);

      return response
          .map((data) => CategoryModel.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat kategori: $e');
    }
  }

  // =====================================
  // 2. GET CATEGORY BY ID
  // =====================================
  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final List<dynamic> response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .limit(1);

      if (response.isEmpty) return null;

      return CategoryModel.fromJson(Map<String, dynamic>.from(response.first as Map));
    } catch (e) {
      throw Exception('Gagal memuat kategori: $e');
    }
  }

  // =====================================
  // 3. ADD CATEGORY (CREATE)
  // =====================================
  Future<void> addCategory(String name, String type) async {
    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      await _supabase.from(_tableName).insert({
        'name': name,
        'type': type,
        'user_id': currentUser.id,
      });
    } catch (e) {
      throw Exception('Gagal membuat kategori: $e');
    }
  }

  // =====================================
  // 4. UPDATE CATEGORY
  // =====================================
  Future<void> updateCategory(String id, {String? name, String? type}) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (type != null && (type == 'income' || type == 'expense')) data['type'] = type;

      if (data.isEmpty) return;

      await _supabase.from(_tableName).update(data).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengubah kategori: $e');
    }
  }

  // =====================================
  // 5. DELETE CATEGORY
  // =====================================
  Future<void> deleteCategory(String id) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus kategori: $e');
    }
  }
}