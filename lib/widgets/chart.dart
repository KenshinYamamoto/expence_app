import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  String japaneseDay;
  final List<String> englishDaies = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> japaneseDaies = [
    '月',
    '火',
    '水',
    '木',
    '金',
    '土',
    '日',
  ];

  Chart(this.recentTransactions);

  // 過去7日分の取引記録が格納されたList
  List<Map<String, Object>> get groupedTransactionValues {
    // Listを7個生成する
    return List.generate(
      7,
      (index) {
        double totalSum = 0;
        // index=1だったら、1日引いた日付が生成される
        final weekDay = DateTime.now().subtract(
          Duration(
            days: index,
          ),
        );

        for (int i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }

        for (int i = 0; i < englishDaies.length; i++) {
          // DateFormat.E(date)は、Mon,Tue...のような感じで英語の曜日3文字を取ってくる
          if (DateFormat.E().format(weekDay).toString() == englishDaies[i]) {
            japaneseDay = japaneseDaies[i];
          }
        }

        return {
          'day': japaneseDay,
          // 'day': DateFormat.E()
          //     .format(weekDay)
          //     .substring(0, 1), // 曜日の0文字目以上、1文字目未満の文字を取得する(要するに0文字目のみ取得する)
          'amount': totalSum,
        };
      },
    ).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // ドロップシャドウを更に強調
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map(
            (data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
