import 'package:hive_sync_firebase/data/models/transaction_model.dart';

abstract class RemoteTransactionDataSource {
  Future<void> uploadTransaction(TransactionModel model);
}
