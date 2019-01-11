import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xpens/xpens/models/expense.dart';
import 'package:xpens/xpens/services/expense_service.dart';

class RecentExpenses extends StatefulWidget {
  @override
  createState() => _ExpensesListState();
}

class _ExpensesListState extends State {
  var expenses = new List<Expense>();
  var expenseService = new ExpenseService();
  _getExpenses() {
    expenseService.getExpensesForUser("send2tanmay@gmail.com").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        expenses = list.map((model) => Expense.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getExpenses();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          //return ListTile(title: Text(expenses[index].typeOfExpense));
          return EachItem(expenses[index]);
        });
  }
}

/*class ExpensesList extends State<RecentExpenses> {
  */ /*List<Expense> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];*/ /*
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        reverse: false,
        itemBuilder: (_, int index) => EachList(this.Names[index]),
        itemCount: this.Names.length,
      ),
    );
  }
}
*/
class EachItem extends StatelessWidget {
  final Expense expense;
  EachItem(this.expense);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                expense.amount,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              maxRadius: 40,
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            Text(
              expense.typeOfExpense,
              style: TextStyle(fontSize: 20.0),
            ),
            Padding(padding: EdgeInsets.only(right: 5.0)),
            Column(
              children: <Widget>[
                Text(
                  expense.email.split(' ')[0],
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 5.0)),
                Text(
                  expense.date,
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
