// lib/core/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_sync_firebase/data/models/transaction_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService(this._firestore);

  /// Upload a transaction to Firestore
  Future<void> uploadTransaction(TransactionModel model) async {
    try {
      await _firestore.collection('transactions').doc(model.id).set({
        'id': model.id,
        'amount': model.amount,
        'note': model.note,
        'date': model.date.toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Optional: fetch all remote transactions (not needed for offline-first)
  Future<List<TransactionModel>> fetchAllTransactions() async {
    try {
      final snapshot = await _firestore.collection('transactions').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TransactionModel(
          id: data['id'],
          amount: (data['amount'] as num).toDouble(),
          note: data['note'],
          date: DateTime.parse(data['date']),
          isSynced: true,
        );
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
