import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<Either<String, List<TransactionEntity>>> getAllTransactions();
  Future<Either<String, List<TransactionEntity>>>
  syncLocalTransactionsToFirebase(); // For offline-first sync
}
