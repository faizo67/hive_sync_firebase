// lib/features/transaction/data/datasources/local_transaction_datasource_impl.dart

import 'package:hive/hive.dart';
import 'package:hive_sync_firebase/data/models/transaction_model.dart';
import 'package:hive_sync_firebase/domain/repositories/local_transaction_repo.dart';

class LocalTransactionDataSourceImpl implements LocalTransactionDataSource {
  final Box<TransactionModel> box;

  LocalTransactionDataSourceImpl(this.box);

  @override
  Future<void> saveTransaction(TransactionModel model) async {
    await box.put(model.id, model);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return box.values.toList();
  }

  @override
  Future<List<TransactionModel>> getPendingSyncTransactions() async {
    return box.values.where((t) => t.isSynced == false).toList();
  }

  @override
  Future<void> markAsPendingSync(String id) async {
    final model = box.get(id);
    if (model != null) {
      final updated = model.copyWith(isSynced: false);
      await box.put(id, updated);
    }
  }

  @override
  Future<void> markAsSynced(String id) async {
    final model = box.get(id);
    if (model != null) {
      final updated = model.copyWith(isSynced: true);
      await box.put(id, updated);
    }
  }
}
