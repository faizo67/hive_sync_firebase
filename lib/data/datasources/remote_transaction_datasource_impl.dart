// lib/features/transaction/data/datasources/remote_transaction_datasource_impl.dart

import 'package:hive_sync_firebase/core/services/firebase_service.dart';
import 'package:hive_sync_firebase/data/models/transaction_model.dart';
import 'package:hive_sync_firebase/domain/repositories/remote_transaction_repo.dart';

class RemoteTransactionDataSourceImpl implements RemoteTransactionDataSource {
  final FirebaseService firebaseService;

  RemoteTransactionDataSourceImpl(this.firebaseService);

  @override
  Future<void> uploadTransaction(TransactionModel model) async {
    await firebaseService.uploadTransaction(model);
  }
}
