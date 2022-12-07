import 'package:flutter/material.dart';

// Transaction: 取引。取引を便利に作成する情報を格納する
class Transaction {
  // Transaction生成時に値が代入されるが、代入後は決して値が変更される事は無いので、finalを付加する
  final String id; // 各トランザクションを識別するユニークなID
  final String title; // 使った金額が何であるのか
  final double amount; // 使用金額
  final DateTime date; // 日付

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });
}
