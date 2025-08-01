import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:hive_sync_firebase/domain/repositories/transaction_repository.dart';

class GetTransactionUseCase {
  final TransactionRepository repository;

  GetTransactionUseCase(this.repository);

  Future<Either<String, List<TransactionEntity>>> call() async {
    return Right(
      (await repository.getAllTransactions()) as List<TransactionEntity>,
    );
  }
}
