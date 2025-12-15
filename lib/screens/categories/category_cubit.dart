// lib/screens/categories/category_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/category_service.dart';
// PASTIKAN BARIS INI ADA:
import 'category_state.dart'; 

// ... implementasi Cubit ...

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService _categoryService;

  CategoryCubit(this._categoryService) : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryService.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
  
  Future<void> addCategory(String name, String type) async {
    try {
      await _categoryService.addCategory(name, type);
      // Muat ulang data kategori agar UI diperbarui
      await loadCategories(); 
    } catch (e) {
      // Menangani error penambahan
      // Jika state sebelumnya Loaded, kembali ke Loaded setelah error
      if (state is CategoryLoaded) {
          emit(CategoryError(e.toString().replaceFirst('Exception: ', '')));
          emit(state); 
      } else {
          emit(CategoryError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _categoryService.deleteCategory(id);
      await loadCategories(); 
    } catch (e) {
      if (state is CategoryLoaded) {
          emit(CategoryError(e.toString().replaceFirst('Exception: ', '')));
          emit(state); 
      }
    }
  }
}