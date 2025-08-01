import 'package:hive_sync_firebase/data/models/transaction_model.dart';

abstract class LocalTransactionDataSource {
  Future<void> saveTransaction(TransactionModel model);
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getPendingSyncTransactions();
  Future<void> markAsPendingSync(String id);
  Future<void> markAsSynced(String id);
}
