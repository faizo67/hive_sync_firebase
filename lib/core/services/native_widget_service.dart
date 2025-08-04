import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';
import 'package:path_provider/path_provider.dart';

class NativeWidgetService {
  static const _channel = MethodChannel('com.example.device/widget');

  /// Step 1️⃣: Save latest transaction to file
  static Future<void> saveLatestTransactionToFile(
    TransactionEntity transaction,
  ) async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/last_transaction.txt');

    final content = '${transaction.amount} - ${transaction.note}';
    await file.writeAsString(content);
  }

  /// Step 2️⃣: Trigger Android widget update
  static Future<void> updateNativeWidget() async {
    try {
      await _channel.invokeMethod('updateWidget');
    } catch (e) {
      print("Widget update failed: $e");
    }
  }
}
