// lib/screens/reports/report_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/transaction_service.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final TransactionService _transactionService;

  ReportCubit(this._transactionService) : super(ReportInitial());

  Future<void> generateReports() async {
    emit(ReportLoading());
    try {
      final allTransactions = await _transactionService.getTransactions();
      
      // 1. Agregasi Data Bulanan
      final monthlyMap = <String, MonthlySummary>{};
      
      // 2. Agregasi Data Kategori
      final categoryMap = <String, CategoryBreakdown>{};

      for (var t in allTransactions) {
        final monthKey = '${t.transactionDate.year}-${t.transactionDate.month.toString().padLeft(2, '0')}';
        
        // Update Monthly Summary
        final currentSummary = monthlyMap[monthKey] ?? MonthlySummary(monthYear: monthKey, income: 0, expense: 0);
        
        monthlyMap[monthKey] = MonthlySummary(
          monthYear: monthKey,
          income: currentSummary.income + (t.type == 'income' ? t.amount : 0),
          expense: currentSummary.expense + (t.type == 'expense' ? t.amount : 0),
        );

        // Update Category Breakdown (gunakan categoryId sebagai kunci)
        final categoryKey = t.categoryId ?? 'uncategorized';
        final categoryName = t.categoryName ?? 'Uncategorized'; // fallback jika null
        final categoryType = t.categoryType ?? 'expense'; // fallback jika null
        
        final currentCategory = categoryMap[categoryKey] ?? CategoryBreakdown(
          categoryName: categoryName,
          totalAmount: 0,
          type: categoryType,
        );
        
        categoryMap[categoryKey] = CategoryBreakdown(
          categoryName: categoryName,
          type: categoryType,
          totalAmount: currentCategory.totalAmount + t.amount,
        );
      }

      emit(ReportLoaded(
        monthlyData: monthlyMap.values.toList(),
        categoryData: categoryMap.values.toList(),
      ));
    } catch (e) {
      emit(ReportError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}