import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';

abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class AddNewTransaction extends TransactionEvent {
  final TransactionEntity transaction;

  AddNewTransaction(this.transaction);
}

class SyncTransactionEvent extends TransactionEvent {}
