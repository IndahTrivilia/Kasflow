// lib/screens/reports/report_state.dart

import 'package:equatable/equatable.dart';

class MonthlySummary {
  final String monthYear; // cth: "Jan 2025"
  final double income;
  final double expense;
  MonthlySummary({required this.monthYear, required this.income, required this.expense});
}

class CategoryBreakdown {
  final String categoryName;
  final double totalAmount;
  final String type;
  CategoryBreakdown({required this.categoryName, required this.totalAmount, required this.type});
}

abstract class ReportState extends Equatable {
  final List<MonthlySummary> monthlyData;
  final List<CategoryBreakdown> categoryData;
  const ReportState({this.monthlyData = const [], this.categoryData = const []});

  @override
  List<Object> get props => [monthlyData, categoryData];
}

class ReportInitial extends ReportState {}
class ReportLoading extends ReportState {}
class ReportLoaded extends ReportState {
  const ReportLoaded({
    required List<MonthlySummary> monthlyData, 
    required List<CategoryBreakdown> categoryData
  }) : super(monthlyData: monthlyData, categoryData: categoryData);
  
  @override
  List<Object> get props => [monthlyData, categoryData];
}
class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);

  @override
  List<Object> get props => [message];
}