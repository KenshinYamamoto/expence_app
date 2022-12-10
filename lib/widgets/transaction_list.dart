import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  void _showDialog(String id, BuildContext context) {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                'Attention!',
                style: TextStyle(color: Colors.red),
              ),
              content: Text('Are you sure you want to delete the record?'),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    deleteTransaction(id);
                    Navigator.pop(context);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Attention!',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text('Are you sure you want to delete the record?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteTransaction(id);
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
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
                  SizedBox(
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
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                elevation: 6,
                child: ListTile(
                  // leadingは、ListTileの先頭の要素
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text(
                          // '¥${userTransactions[index].amount.toStringAsFixed(0)}'),
                          '¥${NumberFormat('#,##0').format(userTransactions[index].amount)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userTransactions[index].title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(userTransactions[index].date),
                  ),
                  // デバイスの横幅が360以上だったらラベル付きのボタンを生成する
                  trailing: MediaQuery.of(context).size.width > 360
                      ? TextButton.icon(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            'Delete',
                          ),
                          onPressed: () =>
                              _showDialog(userTransactions[index].id, context),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).primaryColor,
                          onPressed: () =>
                              _showDialog(userTransactions[index].id, context),
                        ),
                ),
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
