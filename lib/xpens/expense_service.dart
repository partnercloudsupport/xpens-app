import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xpens/xpens/expense.dart';

class ExpenseService {
  static const _serviceUrl = 'http://192.168.1.14:8080/expenses/add';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Expense> createExpense(Expense expense) async {
    try {
      String json = _toJson(expense);
      final response =
          await http.put(_serviceUrl, headers: _headers, body: json);
      var e = _fromJson(response.body);
      print('response: $e');
      return e;
    } catch (e) {
      print('Server Exception!!!');
      print(e);
      return null;
    }
  }

  Expense _fromJson(String jsonExpense) {
    Map<String, dynamic> map = json.decode(jsonExpense);
    var expense = new Expense();
    expense.extraTags = map['extraTags'];
    expense.isRecurring = map['isRecurring'];
    expense.typeOfExpense = map['typeOfExpense'];
    expense.amount = map['amount'];
    expense.date = map['localDate'];
    expense.isExpected = map['isExpected'];
    expense.isFuturistic = map['isFuturistic'];
    expense.isLeisure = map['isLeisure'];
    expense.email = map['userEmail'];
    expense.individualOrFamily = map['levelOfExpense'];

    //contact.dob = new DateFormat.yMd().parseStrict(map['dob']);
    return expense;
  }

  String _toJson(Expense expense) {
    var mapData = new Map();
    mapData["amount"] = expense.amount;
    //mapData["dob"] = new DateFormat.yMd().format(contact.dob);
    mapData["userEmail"] = "send2tanmay@gmail.com";
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
