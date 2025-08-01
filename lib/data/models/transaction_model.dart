// lib/features/transaction/data/models/transaction_model.dart

import 'package:hive/hive.dart';
import 'package:hive_sync_firebase/domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0) // You can change typeId if needed
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String note;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final bool isSynced;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.note,
    required this.date,
    required this.isSynced,
  });

  // Convert to domain entity
  TransactionEntity toEntity() =>
      TransactionEntity(id: id, amount: amount, note: note, date: date);

  // Create from domain entity
  static TransactionModel fromEntity(TransactionEntity entity) =>
      TransactionModel(
        id: entity.id,
        amount: entity.amount,
        note: entity.note,
        date: entity.date,
        isSynced: false, // default to false when creating new
      );

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? note,
    DateTime? date,
    bool? isSynced,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
