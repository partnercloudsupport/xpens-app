import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'expense.dart';
import 'expense_service.dart';

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
      home: new MyHomePage(title: 'Xpens - Add Expense'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<String> _expenseTypes = <String>[
    '',
    'Grocery',
    'Utility',
    'Household',
    'Travel',
    'Health',
    'Entertainment',
    'Electronics',
    'Personal',
    'Miscellaneous',
  ];
  String _type = '';

  //Contact newContact = new Contact();
  Expense newExpense = new Expense();
  final TextEditingController _controller = new TextEditingController();

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat('EEE, M/d/y').format(result);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat('EEE, M/d/y').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  bool isAmountValid(String input) {
    final RegExp regex = new RegExp(r"^[0-9]+(\.[0-9]{1,2})?$");
    return regex.hasMatch(input);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      newExpense.isExpected = _expected;
      newExpense.isFuturistic = _futuristic;
      newExpense.isLeisure = _leisure;
      newExpense.isRecurring = _recurring;
      newExpense.date = _controller.text;
      print('recurring : ${newExpense.isRecurring}');
      print('leisure: ${newExpense.isLeisure}');
      print('futuristic: ${newExpense.isFuturistic}');
      print('expected: ${newExpense.isExpected}');
      print('date: ${newExpense.date}');

      newExpense.individualOrFamily =
          (radioValue == 0) ? 'Individual' : 'Family';
      var expenseService = new ExpenseService();
      expenseService.createExpense(newExpense).then(
          (value) => showMessage('Success: New expense created!', Colors.blue));
      showDialog(
        context: context,
        builder: (_) => new Dialog(
            insetAnimationCurve: ElasticInCurve(),
            child: Container(
              padding: EdgeInsets.all(50),
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.rectangle),
              child: Text(
                "Expense Added!!!",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      );
      _type = '';
      _formKey.currentState.reset();
    }
  }

  bool _expected = false;
  bool _leisure = false;
  bool _futuristic = false;
  bool _recurring = false;
  int radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.all(25),
                children: <Widget>[
                  //amount field
                  TextFormField(
                    decoration: const InputDecoration(
                      prefix: Text(
                        "\$ ",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      hintText: 'Enter expense amount',
                      labelText: 'Amount',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 10,
                          color: Colors.blue,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [new LengthLimitingTextInputFormatter(9)],
                    validator: (val) => isAmountValid(val)
                        ? null
                        : 'Amount invalid. Only 2 digits after decimal.',
                    onSaved: (val) => newExpense.amount = val,
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  //DATE text field and a button to select date
                  Row(children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date of Expense',
                            border: OutlineInputBorder(
                              gapPadding: 4,
                              borderSide: BorderSide(
                                width: 10,
                                color: Colors.blue,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          enabled: false,
                          controller: _controller,
                          keyboardType: TextInputType.datetime,
                          validator: (val) =>
                              isValidDob(val) ? null : 'Not a valid date',
                          onSaved: (val) => newExpense.date = val),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    RaisedButton(
                      textTheme: ButtonTextTheme.primary,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 1,
                      child: Text(
                        "Pick Date",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: (() {
                        _chooseDate(context, _controller.text);
                      }),
                    )
                  ]),
                  Padding(padding: EdgeInsets.all(5)),
                  //Type of Expense dropdown
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Type of Expense',
                          errorText: state.hasError ? state.errorText : null,
                          border: OutlineInputBorder(
                            gapPadding: 4,
                            borderSide: BorderSide(
                              width: 10,
                              color: Colors.blue,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        isEmpty: _type == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _type,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _type = newValue;
                                newExpense.typeOfExpense = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _expenseTypes.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return (val != '' && val != null)
                          ? null
                          : 'Please select type';
                    },
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.blueGrey,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child:
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      Padding(padding: EdgeInsets.all(25)),
                      Text(
                        "Individual",
                        style: TextStyle(
                            decorationStyle: TextDecorationStyle.solid,
                            fontSize: 20),
                      ),
                      Radio<int>(
                        value: 0,
                        groupValue: radioValue,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onChanged: handleRadioValueChanged,
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        "Family",
                        style: TextStyle(
                            decorationStyle: TextDecorationStyle.solid,
                            fontSize: 20),
                      ),
                      Radio<int>(
                        value: 1,
                        groupValue: radioValue,
                        onChanged: handleRadioValueChanged,
                      ),
                    ]),
                  ),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (bool newValue) {
                      setState(() {
                        _expected = newValue;
                      });
                    },
                    title: Text("Expected"),
                  ),
                  SwitchListTile.adaptive(
                    value: _futuristic,
                    onChanged: (bool newValue) {
                      setState(() {
                        _futuristic = newValue;
                      });
                    },
                    title: Text("Futuristic"),
                  ),
                  SwitchListTile.adaptive(
                    value: _leisure,
                    onChanged: (bool newValue) {
                      setState(() {
                        _leisure = newValue;
                      });
                    },
                    title: Text("Leisure"),
                  ),
                  SwitchListTile.adaptive(
                    value: _recurring,
                    onChanged: (bool newValue) {
                      setState(() {
                        _recurring = newValue;
                      });
                    },
                    title: Text("Recurring"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 4,
                        borderSide: BorderSide(
                          width: 10,
                          color: Colors.blue,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: 'Add comma separated tags',
                      labelText: 'Tags',
                    ),
                    onSaved: (val) =>
                        newExpense.extraTags = handleExtraTags(val),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                    child: RaisedButton(
                      textTheme: ButtonTextTheme.normal,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 1,
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _submitForm,
                    ),
                  ),
                ],
              ))),
    );
  }

  List<String> handleExtraTags(String val) {
    if (val != null) {
      return val
          .split(",")
          .map((s) => s.trim().toLowerCase())
          .toSet()
          .toList(growable: true);
    }
    return new List<String>();
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }
}
