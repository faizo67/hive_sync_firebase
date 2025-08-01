// lib/features/transaction/presentation/pages/transaction_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_bloc.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_event.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_state.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<TransactionBloc>().add(SyncTransactionEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text("No transactions found."));
            }
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final t = state.transactions[index];
                return ListTile(
                  title: Text(t.note),
                  subtitle: Text("${t.amount} • ${t.date.toLocal()}"),
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final amountController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Transaction"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: "Note"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final note = noteController.text.trim();
              final amount = double.tryParse(amountController.text.trim());

              if (note.isNotEmpty && amount != null) {
                final newTransaction = TransactionEntity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  amount: amount,
                  note: note,
                  date: DateTime.now(),
                );
                context.read<TransactionBloc>().add(
                  AddNewTransaction(newTransaction),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
