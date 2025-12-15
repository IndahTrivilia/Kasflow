// lib/screens/auth/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
// UBAH BARIS IMPORT INI: Sembunyikan 'AuthState' Supabase
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; 

import '../../services/auth_service.dart'; 
import '../../models/user_model.dart';      
import 'auth_state.dart';                 // AuthState Cubit kita
// ...

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    // Cek status sesi saat Cubit dibuat
    _checkInitialAuthStatus();
  }

  // Cek apakah Admin sudah login saat aplikasi dibuka
  void _checkInitialAuthStatus() {
    final user = _authService.getCurrentUser();
    if (user != null) {
      // Jika ada sesi aktif, pindah ke status sukses
      emit(AuthSuccess(UserModel.fromSupabaseUser(user)));
    } else {
      // Jika tidak ada, tetap di AuthInitial (siap untuk login)
      emit(AuthInitial());
    }
  }

  // Fungsi untuk proses Login Admin
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final User? user = await _authService.signInAdmin(email, password);
      
      if (user != null) {
        // Jika Supabase mengembalikan user, konversi dan emit sukses
        emit(AuthSuccess(UserModel.fromSupabaseUser(user)));
      } else {
        // Seharusnya tidak terjadi jika signInAdmin berhasil
        emit(const AuthFailure("Login gagal, tidak ada data pengguna."));
      }
    } catch (e) {
      // Tangkap Exception dari AuthService
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Fungsi untuk proses Logout Admin
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(AuthLogoutSuccess());
    } catch (e) {
      // Tangkap Exception dari AuthService
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}