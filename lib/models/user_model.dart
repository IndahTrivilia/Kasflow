// lib/models/user_model.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;

  UserModel({
    required this.id,
    required this.email,
  });

  // Membuat UserModel dari objek User Supabase
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? 'Tidak Diketahui', // Email mungkin null jika otentikasi non-email
    );
  }
}