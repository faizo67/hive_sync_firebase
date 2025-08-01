import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';

import '../../core/error/failure.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Future<Either<String, List<TransactionEntity>>> getAllTransactions();
  Future<Either<String, List<TransactionEntity>>>
  syncLocalTransactionsToFirebase(); // For offline-first sync
}
