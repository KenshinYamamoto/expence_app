import 'dart:io';

import 'package:expense_planner/widgets/transaction_item.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  const TransactionList(this.userTransactions, this.deleteTransaction);

  void _showDialog(String id, BuildContext context) {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text(
                'Attention!',
                style: TextStyle(color: Colors.red),
              ),
              content:
                  const Text('Are you sure you want to delete the record?'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    deleteTransaction(id);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Attention!',
                  style: TextStyle(color: Colors.red),
                ),
                content:
                    const Text('Are you sure you want to delete the record?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteTransaction(id);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  // 空白。ただ間を開けるためのもの
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    // 画像のサイズ設定
                    height: constraints.maxHeight * 0.6,
                    // Imageの追加方法。pubspec.yamlへの追記も忘れずに
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover, // デバイスサイズによって動的に
                    ),
                  ),
                ],
              );
            },
          )
        // パフォーマンスを意識したScrollの生成
        : ListView.builder(
            // ListViewを使用する際はListの要素数を記述すること
            itemCount: userTransactions.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                transaction: userTransactions[index],
                showAttention: _showDialog,
              );
              // return Card(
              //   child: Row(children: [
              //     // Containerでないと設定できない項目も多々ある(decoration, margin, padding等)
              //     Flexible(
              //       child: Container(
              //         // decorationでBorderを設定
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Theme.of(context).primaryColor,
              //             width: 2,
              //           ),
              //         ),
              //         // symmetricで上下左右へmarginを設定可能
              //         margin: EdgeInsets.symmetric(
              //           vertical: 10,
              //           horizontal: 15,
              //         ),
              //         // paddingの設定も可能
              //         padding: EdgeInsets.all(10),
              //         child: FittedBox(
              //           child: Text(
              //             '\$${userTransactions[index].amount.toStringAsFixed(2)}',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 20,
              //               color: Theme.of(context).primaryColor,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     Column(
              //       // 子要素を左寄せ
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           userTransactions[index].title,
              //           style: Theme.of(context).textTheme.headline6,
              //         ),
              //         Text(
              //           // DateFormatで日付を見やすく(package:intl/intl.dart)をimport忘れずに
              //           DateFormat.yMMMMd()
              //               .format(userTransactions[index].date),
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     )
              //   ]),
              // );
            },
          );
  }
}
