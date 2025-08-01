import 'package:dartz/dartz.dart';
import 'package:hive_sync_firebase/core/error/failure.dart';
import 'package:hive_sync_firebase/data/models/transaction_model.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:hive_sync_firebase/domain/repositories/local_transaction_repo.dart';
import 'package:hive_sync_firebase/domain/repositories/remote_transaction_repo.dart';
import 'package:hive_sync_firebase/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalTransactionDataSource localDataSource;
  final RemoteTransactionDataSource remoteDataSource;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, void>> addTransaction(TransactionEntity entity) async {
    final model = TransactionModel.fromEntity(entity);
    await localDataSource.saveTransaction(model);

    try {
      await remoteDataSource.uploadTransaction(model);
      await localDataSource.markAsSynced(model.id);
      return const Right(null);
    } catch (e) {
      await localDataSource.markAsPendingSync(model.id);
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<String, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final localModels = await localDataSource.getAllTransactions();
      return Right(localModels.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TransactionEntity>>>
  syncLocalTransactionsToFirebase() async {
    final pendingModels = await localDataSource.getPendingSyncTransactions();

    for (final model in pendingModels) {
      try {
        await remoteDataSource.uploadTransaction(model);
        await localDataSource.markAsSynced(model.id);
      } catch (e) {
        return Left(e.toString()); // return error immediately on failure
      }
    }

    // ✅ Return Right with updated transactions after syncing
    final syncedModels = await localDataSource.getAllTransactions();
    return Right(syncedModels.map((m) => m.toEntity()).toList());
  }
}
