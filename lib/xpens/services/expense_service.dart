import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xpens/xpens/models/expense.dart';

class ExpenseService {
  //static const _serviceUrl = 'http://192.168.1.14:8080/expenses/add';
  static const _serviceUrl = 'https://9a54449d.ngrok.io/xpens-manage/expenses';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Expense> createExpense(Expense expense) async {
    try {
      String json = _toJson(expense);
      final response =
          await http.put(_serviceUrl + "/add", headers: _headers, body: json);
      var e = _fromJson(response.body);
      print('response: $e');
      return e;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return e;
    }
  }

  /*Future<List<Expense>> getAllExpenses(String email) async {
    try {
      final response = await http.get(_serviceUrl + "/all", headers: _headers);
      var e = _fromJson(response.body);
      print('response: $e');
      return (e as List).map((x) => _fromJson(x)).toList();
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return e;
    }
  }*/

  Future getExpensesForUser(String email) {
    return http.get(_serviceUrl + "/all");
  }

  static Expense _fromJson(String jsonExpense) {
    Map<String, dynamic> map = json.decode(jsonExpense);
    var expense = new Expense(
        map['amount'],
        map['extraTags'],
        map['isFuturistic'],
        map['isLeisure'],
        map['isExpected'],
        map['isRecurring'],
        map['localDate'],
        map['userEmail'],
        map['typeOfExpense'],
        map['levelOfExpense']);
    return expense;
  }

  String _toJson(Expense expense) {
    var mapData = new Map();
    mapData["amount"] = expense.amount;
    //mapData["dob"] = new DateFormat.yMd().format(contact.dob);
    mapData["userEmail"] = expense.email;
    mapData["localDate"] =
        (expense.date == null || expense.date.trim().length <= 0)
            ? new DateFormat('EEE, M/d/y').format(DateTime.now())
            : expense.date;
    mapData["isExpected"] = expense.isExpected;
    mapData["isFuturistic"] = expense.isFuturistic;
    mapData["isLeisure"] = expense.isLeisure;
    mapData["isRecurring"] = expense.isRecurring;
    mapData["typeOfExpense"] = expense.typeOfExpense;
    mapData["extraTags"] = expense.extraTags;
    mapData["levelOfExpense"] = expense.individualOrFamily;

    String jsonExpense = json.encode(mapData);
    return jsonExpense;
  }
}
