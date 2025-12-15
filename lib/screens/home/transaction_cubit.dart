// lib/screens/home/transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionService _transactionService;

  TransactionCubit(this._transactionService) : super(TransactionInitial());

  Future<void> loadAllData() async {
    emit(TransactionLoading());
    try {
      final transactions = await _transactionService.getTransactions();
      final balance = await _transactionService.getBalanceSummary();
      
      emit(TransactionLoaded(transactions: transactions, balance: balance));
    } catch (e) {
      emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      await _transactionService.addTransaction(data);
      // Muat ulang data setelah penambahan berhasil
      await loadAllData(); 
    } catch (e) {
      // Tampilkan error saat penambahan, tanpa mengubah state utama
      final currentState = state;
      if (currentState is TransactionLoaded) {
          emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
          emit(currentState); // Kembali ke state Loaded setelah menampilkan error
      } else {
          emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      await _transactionService.updateTransaction(id, data);
      // Muat ulang data setelah update berhasil
      await loadAllData();
    } catch (e) {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
        emit(currentState); // Kembali ke state Loaded setelah menampilkan error
      } else {
        emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionService.deleteTransaction(id);
      // Muat ulang data setelah hapus berhasil
      await loadAllData();
    } catch (e) {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
        emit(currentState); // Kembali ke state Loaded setelah menampilkan error
      } else {
        emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      return await _transactionService.getTransactionById(id);
    } catch (e) {
      emit(TransactionError(e.toString().replaceFirst('Exception: ', '')));
      return null;
    }
  }
}