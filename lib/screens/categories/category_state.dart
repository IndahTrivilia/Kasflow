// lib/screens/categories/category_state.dart

import 'package:equatable/equatable.dart';
import '../../models/category_model.dart';

abstract class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  const CategoryState({this.categories = const []});

  @override
  List<Object> get props => [categories];
}

class CategoryInitial extends CategoryState {}
class CategoryLoading extends CategoryState {}
class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required List<CategoryModel> categories})
      : super(categories: categories);
  
  @override
  List<Object> get props => [categories];
}
class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}