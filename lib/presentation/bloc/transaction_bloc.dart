import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:hive_sync_firebase/domain/usecases/add_transaction.dart';
import 'package:hive_sync_firebase/domain/usecases/get_transactions.dart';
import 'package:hive_sync_firebase/domain/usecases/sync_transactions.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_event.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUseCase addTransaction;
  final GetTransactionUseCase getTransactions;
  final SyncTransactionUseCase syncTransactions;

  TransactionBloc({
    required this.addTransaction,
    required this.getTransactions,
    required this.syncTransactions,
  }) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoad);
    on<AddNewTransaction>(_onAdd);
    on<SyncTransactionEvent>(_onSync);
  }

  Future<void> _onLoad(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());

    final result = await getTransactions();

    result.fold(
          (error) => emit(TransactionError(error)),
          (transactions) => emit(TransactionLoaded(transactions)),
    );
  }

  Future<void> _onAdd(
      AddNewTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    final result = await addTransaction(event.transaction);

    result.fold(
          (error) => emit(TransactionError(error.toString())), // Handle failure
          (_) => add(LoadTransactions()), // On success, refresh list
    );
  }

  Future<void> _onSync(
    SyncTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      syncTransactions.call();
      add(LoadTransactions()); // Refresh list
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
