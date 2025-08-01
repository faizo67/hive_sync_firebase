import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/core/error/failure.dart';
import 'package:hive_sync_firebase/domain/repositories/transaction_repository.dart';

class SyncTransactionUseCase {
  final TransactionRepository repository;

  SyncTransactionUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    // ignore: void_checks
    return Right(await repository.syncLocalTransactionsToFirebase());
  }
}
