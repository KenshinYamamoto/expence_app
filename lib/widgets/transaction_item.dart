import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.showAttention,
  }) : super(key: key);

  final Transaction transaction;
  final Function showAttention;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      elevation: 6,
      child: ListTile(
        // leadingは、ListTileの先頭の要素
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                // '¥${userTransactions[index].amount.toStringAsFixed(0)}'),
                '¥${NumberFormat('#,##0').format(transaction.amount)}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        // デバイスの横幅が360以上だったらラベル付きのボタンを生成する
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
                label: const Text(
                  'Delete',
                ),
                onPressed: () => showAttention(transaction.id, context),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).primaryColor,
                onPressed: () => showAttention(transaction.id, context),
              ),
      ),
    );
    ;
  }
}
