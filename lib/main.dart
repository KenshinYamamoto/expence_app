import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

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
  bool _showChart = false;

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
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            middle: Text(
              // middleがtitleの代わり
              'Personal Expenses',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
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
                icon: Icon(
                  Icons.add,
                  size: 35,
                ),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final Container txListWidget = Container(
        // transactionListに画面全体の70%分の高さを割り当てる
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_transactions, _deleteTransaction));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // ColumnのmainAxisAlignmentで位置を調整可能
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Show Chart!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).primaryColor,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandScape)
              Container(
                  // chartに画面全体の40%分の高さを割り当てる
                  // mediaQuery.size.height: デバイスの高さ
                  // appBar.prefferredSize.height: appBarの高さ
                  // mediaQuery.padding.top: 1番上のステータスバーの高さ
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandScape) txListWidget,
            if (isLandScape)
              _showChart
                  ?
                  // Chartを格納しているContainer
                  Container(
                      // chartに画面全体の40%分の高さを割り当てる
                      // mediaQuery.size.height: デバイスの高さ
                      // appBar.prefferredSize.height: appBarの高さ
                      // mediaQuery.padding.top: 1番上のステータスバーの高さ
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.65,
                      child: Chart(_recentTransactions))
                  : txListWidget
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            // floatingButtonの位置決定
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            // floatingButtonの生成
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
