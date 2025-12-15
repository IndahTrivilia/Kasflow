// lib/screens/home/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../management/add_transaction_screen.dart';
import '../categories/category_management_page.dart';
import '../reports/report_page.dart';
import '../../widgets/transaction_tile.dart';
import 'transaction_cubit.dart';
import 'transaction_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TransactionCubit>().loadAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Kasflow Dashboard'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.category),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryManagementPage()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportPage()),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TransactionCubit>().loadAllData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Balance Card
                BlocBuilder<TransactionCubit, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading && state.transactions.isEmpty) {
                      return Container(
                        height: 180,
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.teal.shade400, Colors.teal.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    final balance = state.balance;
                    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
                    
                    return Container(
                      margin: const EdgeInsets.all(16),
                      height: 180,
                      child: Card(
                        elevation: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: balance >= 0 
                                ? [Colors.teal.shade400, Colors.teal.shade600]
                                : [Colors.red.shade400, Colors.red.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Balance',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    balance >= 0 ? Icons.trending_up : Icons.trending_down,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                formatter.format(balance),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Updated ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Quick Actions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildQuickActionCard(
                                  context,
                                  'Add Income',
                                  Icons.add_circle_outline,
                                  Colors.green,
                                  () => _navigateToAddTransaction(context, 'income'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildQuickActionCard(
                                  context,
                                  'Add Expense',
                                  Icons.remove_circle_outline,
                                  Colors.red,
                                  () => _navigateToAddTransaction(context, 'expense'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Recent Transactions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent Transactions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to full transaction list
                                },
                                child: const Text('View All'),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<TransactionCubit, TransactionState>(
                          builder: (context, state) {
                            if (state is TransactionError) {
                              return Container(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red.shade300,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Error: ${state.message}',
                                        style: TextStyle(color: Colors.red.shade600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            if (state.transactions.isEmpty && state is! TransactionLoading) {
                              return Container(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No transactions yet',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Add your first transaction to get started',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            final displayTransactions = state.transactions.take(5).toList();
                            
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: displayTransactions.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 4),
                              itemBuilder: (context, index) {
                                final transaction = displayTransactions[index];
                                
                                return TransactionTile(
                                  tr: {
                                    'id': transaction.id,
                                    'amount': transaction.amount,
                                    'type': transaction.type,
                                    'title': transaction.description ?? 'No description',
                                    'description': transaction.categoryName ?? 'Uncategorized',
                                    'date': transaction.transactionDate.toIso8601String(),
                                  },
                                  onEdit: () => _editTransaction(context, transaction),
                                  onDelete: () => _deleteTransaction(context, transaction.id),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
        
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          onPressed: () => _navigateToAddTransaction(context, null),
          icon: const Icon(Icons.add),
          label: const Text('Add Transaction'),
        ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddTransaction(BuildContext context, String? defaultType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(defaultType: defaultType),
      ),
    ).then((_) {
      // Refresh data when returning from add transaction screen
      if (mounted) {
        context.read<TransactionCubit>().loadAllData();
      }
    });
  }

  void _editTransaction(BuildContext context, dynamic transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(transaction: transaction),
      ),
    ).then((_) {
      if (mounted) {
        context.read<TransactionCubit>().loadAllData();
      }
    });
  }

  void _deleteTransaction(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await context.read<TransactionCubit>().deleteTransaction(transactionId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction deleted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete transaction: \$e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
