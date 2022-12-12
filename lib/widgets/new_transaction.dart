import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  const NewTransaction(this.addNewTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _showDialog(String contentStr) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text(
                  'Attention',
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(contentStr),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isDestructiveAction: true,
                  ),
                ],
              );
            },
          )
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Attention!',
                style: const TextStyle(color: Colors.red),
              ),
              content: Text(contentStr),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
  }

  void _submitData() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedDate == null) {
      _showDialog('必須項目の欠落');
      return;
    }

    try {
      print(double.parse(_amountController.text));
    } catch (e) {
      _showDialog('Amountには数字のみ入力');
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    // Stateクラスの中にaddNewTransactionは特別なプロパティとして保持されているので、
    // 異なるクラスで保持されているaddNewTransactionを実行するには、widget.~の形で実行する
    // widget.~では、ステートクラスの内部からウィジェットクラスのプロパティやメソッドにアクセスすることができる
    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    // ナビゲーション
    Navigator.of(context).pop();
  }

  // DatePicker表示
  void _presentDatePicker() {
    // showDatePickerはFlutterで用意されている関数
    // showDatePickerはFuture<DateTime>を返す
    showDatePicker(
      // contextは、Stateクラスから継承されている
      context: context,
      // Pickerを開いた際に最初に選択される日
      initialDate: DateTime.now(),
      // 選択可能な最初の日(ここでは、2020年以降)
      firstDate: DateTime(2000),
      // 選択可能な最後の日
      lastDate: DateTime.now(),
    ).then((pickedData) {
      if (pickedData == null) {
        // ユーザがキャンセルした場合
        return;
      }
      setState(() {
        _selectedDate = pickedData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // Buttonを右端へ
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
                keyboardType: TextInputType.number, // 数字のみ受付
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date ', _presentDatePicker)
                  ],
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: _submitData,
                  child: Text(
                    'Add transaction!',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.button.color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
