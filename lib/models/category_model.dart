// lib/models/category_model.dart

class CategoryModel {
  final String id; // UUID string
  final String userId; // UUID string (untuk kepemilikan user)
  final String name;
  final String type; // 'income' atau 'expense'
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  // Factory constructor untuk membuat CategoryModel dari data JSON Supabase
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? 'expense').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  // Method untuk mengubah model kembali menjadi Map (JSON) untuk dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      // 'id', 'user_id', 'created_at' di-handle oleh database (auto-generate UUID, auto-timestamp)
    };
  }

  @override
  String toString() => 'CategoryModel(id: $id, name: $name, type: $type)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CategoryModel &&
            other.id == id &&
            other.userId == userId &&
            other.name == name &&
            other.type == type &&
            other.createdAt == createdAt);
  }

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ name.hashCode ^ type.hashCode ^ createdAt.hashCode;
}