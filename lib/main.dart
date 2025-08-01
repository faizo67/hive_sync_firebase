import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_sync_firebase/data/datasources/local_transaction_datasource_imp.dart';
import 'package:hive_sync_firebase/data/datasources/remote_transaction_datasource_impl.dart';
import 'package:hive_sync_firebase/data/repositories/transaction_repository_impl.dart';
import 'package:hive_sync_firebase/domain/usecases/add_transaction.dart';
import 'package:hive_sync_firebase/domain/usecases/get_transactions.dart';
import 'package:hive_sync_firebase/domain/usecases/sync_transactions.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_bloc.dart';
import 'package:hive_sync_firebase/presentation/bloc/transaction_event.dart';
import 'package:hive_sync_firebase/presentation/pages/transaction_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Added Firestore import
import 'core/services/hive_service.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp();

  // ✅ Initialize Hive
  await HiveService.init();

  // ✅ Prepare data sources
  final localDataSource = LocalTransactionDataSourceImpl(
    HiveService.getTransactionBox(),
  );

  final firebaseService = FirebaseService(
    FirebaseFirestore.instance,
  ); // <-- Pass Firestore instance
  final remoteDataSource = RemoteTransactionDataSourceImpl(firebaseService);

  // ✅ Prepare repository
  final repository = TransactionRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );

  // ✅ Prepare use cases
  final addTransaction = AddTransactionUseCase(repository);
  final getTransactions = GetTransactionUseCase(repository);
  final syncTransactions = SyncTransactionUseCase(repository);

  // ✅ Start app with BLoC provider
  runApp(
    MyApp(
      addTransaction: addTransaction,
      getTransactions: getTransactions,
      syncTransactions: syncTransactions,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AddTransactionUseCase addTransaction;
  final GetTransactionUseCase getTransactions;
  final SyncTransactionUseCase syncTransactions;

  const MyApp({
    super.key,
    required this.addTransaction,
    required this.getTransactions,
    required this.syncTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Sync Firebase',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TransactionBloc(
          addTransaction: addTransaction,
          getTransactions: getTransactions,
          syncTransactions: syncTransactions,
        )..add(LoadTransactions()), // Load on startup
        child: const TransactionPage(),
      ),
    );
  }
}
