import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:hive_sync_firebase/domain/repositories/transaction_repository.dart';

import '../../core/error/failure.dart';

class AddTransactionUseCase {
  final TransactionRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call(TransactionEntity transaction) async {
    return await repository.addTransaction(transaction);
  }
}
