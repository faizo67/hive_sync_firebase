// lib/core/services/hive_service.dart

// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_sync_firebase/data/models/transaction_model.dart';

class HiveService {
  static const String transactionBoxName = 'transactions';

  /// Initializes Hive & registers adapters
  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    await Hive.openBox<TransactionModel>(transactionBoxName);
  }

  /// Get the opened transaction box
  static Box<TransactionModel> getTransactionBox() {
    return Hive.box<TransactionModel>(transactionBoxName);
  }

  /// Close all boxes (optional on app exit)
  static Future<void> close() async {
    await Hive.close();
  }
}
