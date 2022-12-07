import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: userTransactions.isEmpty
          ? Column(
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
                  height: 200,
                  // Imageの追加方法。pubspec.yamlへの追記も忘れずに
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover, // デバイスサイズによって動的に
                  ),
                ),
              ],
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
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            // '¥${userTransactions[index].amount.toStringAsFixed(0)}'),
                            '¥${NumberFormat('#,##0').format(userTransactions[index].amount)}',
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () =>
                          deleteTransaction(userTransactions[index].id),
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
            ),
    );
  }
}
