// lib/screens/auth/auth_state.dart

import 'package:equatable/equatable.dart';
import '../../models/user_model.dart'; // Import UserModel

// =======================
// CLASS ABSTRAK (Base State)
// =======================
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// =======================
// STATUS AWAL DAN SUKSES
// =======================

// 1. Inisialisasi: Admin belum login atau belum diperiksa statusnya
class AuthInitial extends AuthState {}

// 2. Login Sukses: Admin berhasil masuk
class AuthSuccess extends AuthState {
  final UserModel user;
  
  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// 3. Logout Sukses: Admin berhasil keluar
class AuthLogoutSuccess extends AuthState {}


// =======================
// STATUS LOADING DAN GAGAL
// =======================

// 4. Proses Loading: Sedang memproses login atau logout
class AuthLoading extends AuthState {}

// 5. Proses Gagal: Terjadi kesalahan
class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}