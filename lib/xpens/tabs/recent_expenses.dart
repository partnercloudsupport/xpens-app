import 'package:flutter/material.dart';

class RecentExpenses extends StatefulWidget {
  @override
  State<RecentExpenses> createState() {
    return ExpensesList();
  }
}

class ExpensesList extends State<RecentExpenses> {
  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];
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

class EachList extends StatelessWidget {
  final String name;
  EachList(this.name);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(name[0]),
            ),
            Padding(padding: EdgeInsets.only(right: 10.0)),
            Text(
              name,
              style: TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}
