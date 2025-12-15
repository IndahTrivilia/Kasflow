// lib/screens/home/transaction_state.dart

import 'package:equatable/equatable.dart';
import '../../models/transaction_model.dart';

abstract class TransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final double balance;
  const TransactionState({this.transactions = const [], this.balance = 0.0});

  @override
  List<Object> get props => [transactions, balance];
}

class TransactionInitial extends TransactionState {}
class TransactionLoading extends TransactionState {}
class TransactionLoaded extends TransactionState {
  const TransactionLoaded({required List<TransactionModel> transactions, required double balance})
      : super(transactions: transactions, balance: balance);

  @override
  List<Object> get props => [transactions, balance];
}
class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}