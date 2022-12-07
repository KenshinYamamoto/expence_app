import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartBar extends StatelessWidget {
  final String label; // 曜日
  final double spendingAmount; // 使用額
  final double spendingPctOfTotal; // 支出割合

  ChartBar(
    this.label,
    this.spendingAmount,
    this.spendingPctOfTotal,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 使用金額
        Container(
          height: 20,
          child: FittedBox(
            child: Text(
              '¥${NumberFormat('#,##0').format(spendingAmount)}', // 整数値を出力
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        // 棒グラフ
        Container(
          height: 60,
          width: 10,
          child: Stack(
            // 3次元的にウィジェットを管理
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              // 下の要素との空きを作る
              FractionallySizedBox(
                // heightFactorに0から1の値を入れる
                // 1なら親のcontainerの高さ(60)と等しくなる
                // 0なら高さ0%、1なら高さ100%という考え方で良い
                heightFactor: spendingPctOfTotal,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4,
        ),
        // 曜日
        Text(
          label,
        ),
      ],
    );
  }
}
