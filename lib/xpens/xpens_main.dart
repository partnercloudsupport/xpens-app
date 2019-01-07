import 'package:flutter/material.dart';
import 'package:xpens/xpens/tabs/add_expense_form.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XPens - Expenses',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Xpens - Add Expense'),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          //drawer: CommonDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.blue[50],
              tabs: [
                Tab(
                  text: "Add Expense",
                ),
                Tab(
                  text: "Recently added",
                ),
                Tab(
                  text: "Analyze",
                ),
              ],
            ),
            elevation: 5,
            title: Text('Xpens - Analyze Expenses Differently'),
          ),
          body: TabBarView(
            children: [
              MyHomePage(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
