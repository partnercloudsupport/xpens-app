class Expense {
  String amount;
  List extraTags;
  bool isFuturistic;
  bool isLeisure;
  bool isExpected;
  bool isRecurring;
  String date;
  String email;
  String typeOfExpense;
  String individualOrFamily;

  Expense(
      String amount,
      List extraTags,
      bool isFuturistic,
      bool isLeisure,
      bool isExpected,
      bool isRecurring,
      String date,
      String email,
      String typeOfExpense,
      String individualOrFamily) {
    this.amount = amount;
    this.extraTags = extraTags;
    this.isFuturistic = isFuturistic;
    this.isLeisure = isLeisure;
    this.isExpected = isExpected;
    this.isRecurring = isRecurring;
    this.date = date;
    this.email = email;
    this.typeOfExpense = typeOfExpense;
    this.individualOrFamily = individualOrFamily;
  }

  Expense.fromJson(Map json)
      : extraTags = json['extraTags'],
        isRecurring = json['isRecurring'],
        typeOfExpense = json['typeOfExpense'],
        amount = json['amount'].toString(),
        date = json['createdDate'],
        isExpected = json['isExpected'],
        isFuturistic = json['isFuturistic'],
        isLeisure = json['isLeisure'],
        email = json['userName'],
        individualOrFamily = json['levelOfExpense'];

  Map toJson() {
    return {
      'extraTags': extraTags,
      'isRecurring': isRecurring,
      'typeOfExpense': typeOfExpense,
      'amount': amount,
      'localDate': date,
      'userEmail': email,
      'levelOfExpense': individualOrFamily,
      'isFuturistic': isFuturistic,
      'isLeisure': isLeisure,
      'isExpected': isExpected
    };
  }
}
