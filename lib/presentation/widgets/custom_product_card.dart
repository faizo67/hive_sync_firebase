import 'package:flutter/material.dart';

import '../../domain/entities/transaction_entity.dart';
import 'custom_transaction_tile.dart';

Card customProductCard(TransactionEntity transaction) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[100]!, Colors.white],
        ),
      ),
      // Use the customProductTile function to create the ListTile
      child: customProductTile(transaction),
    ),
  );
}