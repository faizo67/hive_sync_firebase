import 'package:flutter/material.dart';

import '../../domain/entities/transaction_entity.dart';

ListTile customProductTile(TransactionEntity transaction) {
  return ListTile(
    title: Text(transaction.note),
    subtitle: Text("${transaction.amount} • ${transaction.date.toLocal()}"),
  );
}