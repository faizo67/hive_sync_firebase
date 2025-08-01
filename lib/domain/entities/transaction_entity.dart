class TransactionEntity {
  final String id;
  final double amount;
  final String note;
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.note,
    required this.date,
  });
}
