// lib/services/auth_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Login Admin
  Future<User?> signInAdmin(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // Jika login berhasil, kembalikan User
      return response.user;
    } on AuthException catch (e) {
      // Lempar error untuk ditangani di UI/Cubit
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login: $e');
    }
  }

  // Logout Admin
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Terjadi kesalahan saat logout: $e');
    }
  }
  
  // Mendapatkan status sesi saat ini
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}