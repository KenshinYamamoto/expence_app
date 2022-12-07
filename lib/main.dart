import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses', // バックグラウンドやタスクマネージャ上で表示されるもの
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Quicksand', // デフォルトフォント
        errorColor: Colors.amber,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = []; // 取引記録を全て格納

  // 過去1週間の取引を格納したList
  List<Transaction> get _recentTransactions {
    // 全てのtransactionから、7日前よりも後の取引のみを取得してreturnする
    return _transactions.where((tx) {
      // isAfterは、引数よりも後という意味
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7), // 7日前
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
    );

    setState(() {
      _transactions.add(newTx); // [List].addで要素を追加可能
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // モーダルを生成
    showModalBottomSheet(
      isScrollControlled: true,
      context: ctx, // contextを受け取り、
      // builderがモーダルの中身になる
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // ColumnのmainAxisAlignmentで位置を調整可能
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chartを格納しているContainer
            Chart(_recentTransactions),
            TransactionList(_transactions, _deleteTransaction),
          ],
        ),
      ),
      // floatingButtonの位置決定
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingButtonの生成
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
